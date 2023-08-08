# MemoryLeak

## Installation

- Download the command-line from releases and add it to your project.
- Copy `checkleak` to `/usr/local/bin/` by
```
cp -f /Download/checkleak /usr/local/bin/
```
- Add this script to Xcode build phases and build the project.

- The script only checks the missing `[weak self]` or `[unowned self]` in the changed files.

```
#!/bin/bash

checkleak="checkleak"

# Run checkleak for given filename
run_checkleak() {
    local filename="${SRCROOT}/../${1}"
    if [[ "${filename##*.}" == "swift" ]]; then
        echo "⛔️ ${filename}"
        ${checkleak} "${filename}"
    fi
}

# Check if checkleak is found
if which $checkleak > /dev/null; then
    # Run for both staged and unstaged files
    git diff --name-only | while read filename; do run_checkleak "${filename}"; done
    git diff --cached --name-only | while read filename; do run_checkleak "${filename}"; done
else
    echo "${checkleak} is not found."
        echo "${checkleak} is not found."
        echo "Installation https://github.com/dimohamdy/MemoryLeak"
    exit 0
fi

```
