#!/bin/bash

BUFFER_FILES=()
BUFFER_EXCLUDES=()
PID=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--pid)
            PID="$2"
            shift 2
            ;;
        -f)
            CURRENT_FILE_PATH="$2"
            # Strip any existing protocol to get the raw path
            if [[ "$CURRENT_FILE_PATH" =~ ^current-file:// ]]; then
                CURRENT_FILE_PATH="${CURRENT_FILE_PATH#current-file://}"
            elif [[ "$CURRENT_FILE_PATH" =~ ^file:// ]]; then
                CURRENT_FILE_PATH="${CURRENT_FILE_PATH#file://}"
            fi
            
            # Get relative path from CWD
            if [[ "$CURRENT_FILE_PATH" = /* ]]; then
                # It's an absolute path - make it relative to CWD
                CURRENT_FILE_PATH_FROM_CWD=$(realpath --relative-to="$(pwd)" "$CURRENT_FILE_PATH" 2>/dev/null || echo "$CURRENT_FILE_PATH")
            else
                # Already relative
                CURRENT_FILE_PATH_FROM_CWD="$CURRENT_FILE_PATH"
            fi
            
            # Create CURRENT_FILE with protocol (using the original path)
            CURRENT_FILE="current-file://$CURRENT_FILE_PATH"
            shift 2
            ;;
        -b|--buffer)
            BUFFER_PATH="$2"
            # Strip any existing protocol to get the raw path
            if [[ "$BUFFER_PATH" =~ ^buffer:// ]]; then
                BUFFER_PATH="${BUFFER_PATH#buffer://}"
            elif [[ "$BUFFER_PATH" =~ ^file:// ]]; then
                BUFFER_PATH="${BUFFER_PATH#file://}"
            fi
            
            # Get relative path from CWD for exclusion
            if [[ "$BUFFER_PATH" = /* ]]; then
                # It's an absolute path - make it relative to CWD
                BUFFER_PATH_FROM_CWD=$(realpath --relative-to="$(pwd)" "$BUFFER_PATH" 2>/dev/null || echo "$BUFFER_PATH")
            else
                # Already relative
                BUFFER_PATH_FROM_CWD="$BUFFER_PATH"
            fi
            
            # Add to buffer arrays
            BUFFER_FILES+=("buffer://$BUFFER_PATH")
            BUFFER_EXCLUDES+=("$BUFFER_PATH_FROM_CWD")
            shift 2
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

get_opencode_port() {
  local pid="$1"
  [[ -z "$pid" ]] && return 1
  
  local port
  port=$(lsof -i -P -n -p "$pid" 2>/dev/null | awk '/LISTEN/ && $1 == "opencode" {print $9}' | cut -d: -f2 | head -1)
  
  [[ -n "$port" ]] && echo "$port" && return 0
  return 1
}

get_opencode_agents() {
  local port="$1"
  local search_term="$2"
  local url="http://127.0.0.1:$port/agent"
  local cache_dir="/tmp/opencode-agents"
  
  local response
  response=$(curl -sS "$url" 2>/dev/null)
  [[ -z "$response" ]] && return 1
  
  mkdir -p "$cache_dir"
  
  if command -v jq &>/dev/null; then
    echo "$response" | jq -r '.[] | "\(.name)\t\(.description // "")"' 2>/dev/null | while IFS=$'\t' read -r name desc; do
      if [[ -z "$search_term" ]] || [[ "${name,,}" == *"${search_term,,}"* ]]; then
        local tmpfile="$cache_dir/${name}.md"
        printf '%s\n' "$desc" > "$tmpfile"
        printf 'agent://%s|%s\n' "$name" "$tmpfile"
      fi
    done
  else
    echo "$response" | grep -oP '"name"\s*:\s*"\K[^"]+' | while read -r name; do
      if [[ -z "$search_term" ]] || [[ "${name,,}" == *"${search_term,,}"* ]]; then
        printf 'agent://%s|%s\n' "$name" "$name"
      fi
    done
  fi
}

get_claude_agents() {
  local search_term="$POSITIONAL_ARGS"
  local agents=()
  local cwd="$(pwd)"
  local home="$HOME"
  
  # Directories to search
  local search_dirs=(
    "$cwd/.claude/agents/"
    "$home/.claude/agents/"
  )
  
  # Function to extract name from frontmatter
  extract_agent_name() {
    local filepath="$1"
    
    if [[ ! -f "$filepath" ]]; then
      return 1
    fi
    
    local content
    content=$(cat "$filepath")
    
    # Extract frontmatter between --- markers
    local frontmatter
    frontmatter=$(echo "$content" | awk '/^---$/{flag=!flag; next} flag')
    
    if [[ -z "$frontmatter" ]]; then
      return 1
    fi
    
    # Extract name field
    local name
    name=$(echo "$frontmatter" | grep -oP '^name:\s*\K.*?(?=\s*$)' | head -1)
    
    if [[ -n "$name" ]]; then
      echo "$name"
      return 0
    fi
    
    return 1
  }
  
  # Search each directory
  for dir in "${search_dirs[@]}"; do
    # Check if directory exists
    if [[ -d "$dir" ]]; then
      # Get all .md files in directory
      for filepath in "$dir"*.md; do
        # Skip if glob didn't match any files
        [[ -e "$filepath" ]] || continue
        
        local agent_name
        agent_name=$(extract_agent_name "$filepath")
        
        if [[ -n "$agent_name" ]]; then
          # Filter by search term if provided (case-insensitive)
          if [[ -z "$search_term" ]] || [[ "${agent_name,,}" == *"${search_term,,}"* ]]; then
            agents+=("$agent_name|$filepath")
          fi
        fi
      done
    fi
  done
  
  if [[ ${#agents[@]} -gt 0 ]]; then
    # Print agents with format: agent://name|/path/to/file.md
    for agent in "${agents[@]}"; do
      local name="${agent%%|*}"
      local path="${agent##*|}"
      printf 'agent://%s|%s\n' "$name" "$path"
    done
  fi
}

get_agents() {
  local search_term="$POSITIONAL_ARGS"
  
  if [[ -n "$PID" ]]; then
    local port
    port=$(get_opencode_port "$PID")
    
    if [[ -n "$port" ]]; then
      get_opencode_agents "$port" "$search_term"
      return
    fi
  fi
  
  get_claude_agents
}

[[ -n "$CURRENT_FILE" ]] && echo "$CURRENT_FILE"

for buffer_file in "${BUFFER_FILES[@]}"; do
    echo "$buffer_file"
done

get_agents

# Build fd command with all excludes
FD_EXCLUDES="-E .git"
[[ -n "$CURRENT_FILE_PATH_FROM_CWD" ]] && FD_EXCLUDES="$FD_EXCLUDES -E \"$CURRENT_FILE_PATH_FROM_CWD\""
for exclude in "${BUFFER_EXCLUDES[@]}"; do
    FD_EXCLUDES="$FD_EXCLUDES -E \"$exclude\""
done

# Execute fd with all excludes
eval "fd --type file --type directory $FD_EXCLUDES \"$POSITIONAL_ARGS\"" | sed 's|^|file://|'
