#!/bin/bash

while [[ $# -gt 0 ]]; do
    case $1 in
        -f)
            FILE="$2"
            # Strip any existing protocol and add current-file://
            if [[ "$FILE" =~ ^current-file:// ]]; then
                # Already has current-file://, keep as is
                FILE="$FILE"
            elif [[ "$FILE" =~ ^file:// ]]; then
                # Has file://, replace with current-file://
                FILE="current-file://${FILE#file://}"
            else
                # No protocol, add current-file://
                FILE="current-file://$FILE"
            fi
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

[[ -n "$FILE" ]] && echo "$FILE"
get_claude_agents
fd --type file --type directory -E .git "$POSITIONAL_ARGS" | sed 's|^|file://|'
