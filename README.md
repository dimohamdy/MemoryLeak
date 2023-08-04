# MemoryLeak

## Installation

- Download the command-line from release and add it to your project.

- Add this script to Xcode build phases and build the project.
```
START_DATE=$(date +"%s")

# The path to LeakCheck
LeakChecker="${SRCROOT}/../LeakCheck"

# Run LeakChecker for the given filename
run_leakChecker() {
    local filename="${SRCROOT}/../${1}" # file path could be different
    if [[ "${filename##*.}" == "swift" ]]; then
        echo "⛔️ ${filename}"
        ${LeakChecker} "${filename}"
    fi
}

# Check if LeakChecker is found
if which "$LeakChecker" > /dev/null; then
    # Run for both staged and unstaged files
    git diff --name-only | while read filename; do run_leakChecker "${filename}"; done
    git diff --cached --name-only | while read filename; do run_leakChecker "${filename}"; done
else
    echo "${LeakChecker} is not found."
    exit 0
fi

END_DATE=$(date +"%s")

DIFF=$(($END_DATE - $START_DATE))
echo "LeakChecker took $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds to complete."

```
