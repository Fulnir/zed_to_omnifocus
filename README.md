# zed_to_omnifocus
Create @OmniFocus task from @zed.dev TODO, FIXME, ERROR and WARNING comments.



### Applescript


```applescript
on run argv

	set {tasktag, stem, symbol, tasknote, taskname} to {item 1, item 2, item 3, item 4, item 5} of argv


	tell application "System Events"
		count (every process whose name is "OmniFocus")
		if result < 1 then
			tell application "OmniFocus" to activate
		end if
	end tell

	tell front document of application "OmniFocus"
		try
			set theTag to (first flattened tag where its name is tasktag)
		on error
			set theTag to make new tag with properties {name:tasktag}
		end try
		set theProject to first flattened project where its name = "View of Things"

		tell theProject
			make new task with properties {name:stem & ":" & symbol & ": " & taskname, note:tasknote, primary tag:theTag}

		end tell
	end tell
end run
```

### Tasks

#### Zed Variables

The used Zed [Variables](https://zed.dev/docs/tasks#variables) are.
- ZED_COLUMN: current line column
- ZED_ROW: current line row
- ZED_FILE: absolute path of the currently opened file
- ZED_STEM: stem (filename without extension) of the currently opened file (e.g. main)
- ZED_SYMBOL: currently selected symbol; should match the last symbol shown in a symbol breadcrumb (e.g. mod tests > fn test_task_contexts)
- ZED_SELECTED_TEXT: The selected comment text

scrpt_path omnifocus_tag ZED_STEM defer_days due_days ZED_SYMBOL open_terninal_command comment_text

```json
[
  {
    "label": "Create an 📒ToDo OmniFocus task.",
    "command": "osascript \"/Users/ed/ex/ViewOfThings/omnifocus.scpt\"  \"📒Todo\"  \"$ZED_STEM\"  \"90\" \"180\" \"$ZED_SYMBOL\" \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\"  \"📒 $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always",
    "hide": "always",
    "shell": "system"
  },
  {
    "label": "Create an 🩹FixMe OmniFocus task.",
    "command": "osascript \"/Users/ed/ex/ViewOfThings/omnifocus.scpt\"  \"🩹FixMe\"  \"$ZED_STEM\"  \"7\" \"30\"  \"$ZED_SYMBOL\"  \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\"  \"🩹 $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always",
    "hide": "always",
    "shell": "system"
  },
  {
    "label": "Create an ⚠️Warning OmniFocus task.",
    "command": "osascript \"/Users/ed/ex/ViewOfThings/omnifocus.scpt\"  \"⚠️Warning\"  \"$ZED_STEM\"  \"30\" \"90\"  \"$ZED_SYMBOL\"  \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\"  \"⚠️ $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always",
    "hide": "always",
    "shell": "system"
  },
  {
    "label": "Create an 🛑Error OmniFocus task.",
    "command": "osascript \"/Users/ed/ex/ViewOfThings/omnifocus.scpt\"  \"🛑Error\"  \"$ZED_STEM\"  \"7\" \"90\"  \"$ZED_SYMBOL\"  \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\"  \"🐞 $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always",
    "hide": "always",
    "shell": "system"
  }
]
```

### Keymap

`keymap.json`

```json
[
  {
    "context": "Workspace",
    "bindings": {
      "ctrl-shift-o": [
        "task::Spawn",
        { "task_name": "Create an 📒ToDo OmniFocus task." }
      ]
    }
  },
  {
    "context": "Workspace",
    "bindings": {
      "ctrl-shift-o": [
        "task::Spawn",
        { "task_name": "Create an 🩹FixMe OmniFocus task." }
      ]
    }
  },
  {
    "context": "Workspace",
    "bindings": {
      "ctrl-shift-o": [
        "task::Spawn",
        { "task_name": "Create an ⚠️Warning OmniFocus task." }
      ]
    }
  },
  {
    "context": "Workspace",
    "bindings": {
      "ctrl-shift-o": [
        "task::Spawn",
        { "task_name": "Create an 🛑Error OmniFocus task." }
      ]
    }
  }
]
```

### Snippets

`your_snippets.json`

```json
{
  "todo": {
      "prefix": "to",
      "body": ["# 📒TODO: "],
      "description": "Template for mark TODO"
    },
    "fixme": {
      "prefix": "fix",
      "body": ["# 🩹FIXME: "],
      "description": "Template for mark TODO"
    },
    "error": {
      "prefix": "err",
      "body": ["# 🛑ERROR: "],
      "description": "Template for mark TODO"
    },
    "warning": {
      "prefix": "war",
      "body": ["# ⚠️WARNING: "],
      "description": "Template for mark TODO"
    }
  }
```
