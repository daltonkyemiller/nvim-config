#!/bin/bash
get_claude_agents() {
  local search_term="$1"
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
            agents+=("$agent_name")
          fi
        fi
      done
    fi
  done
  
  if [[ ${#agents[@]} -gt 0 ]]; then
    # Print agents (one per line)
    printf 'agent://%s\n' "${agents[@]}"
  fi
}

get_claude_agents $1 && fd --type file --type directory -E .git "$1" | sed 's|^|file://|'
