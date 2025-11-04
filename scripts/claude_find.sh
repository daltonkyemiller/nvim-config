#!/bin/bash

while [[ $# -gt 0 ]]; do
    case $1 in
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
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

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

[[ -n "$CURRENT_FILE" ]] && echo "$CURRENT_FILE"
get_claude_agents
if [[ -n "$CURRENT_FILE_PATH_FROM_CWD" ]]; then
    fd --type file --type directory -E .git -E "$CURRENT_FILE_PATH_FROM_CWD" "$POSITIONAL_ARGS" | sed 's|^|file://|'
else
    fd --type file --type directory -E .git "$POSITIONAL_ARGS" | sed 's|^|file://|'
fi
