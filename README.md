# zed_to_omnifocus

Create @OmniFocus PRO tasks from @zed.dev TODO, FIXME, ERROR and WARNING comments.



## Installing

- Add the tasks bellow to your `tasks.json` file.
- Add the keymap items bellow to your `keymap.json` file.
- Add the snippets bellow to your `snippets.json` file.
- Open the file `Comment_to_Omnifocus.scpt` with the apples apples `ScriptEditor` and save it as `scpt` file to your Zed config folder  `~/.config/zed/Comment_to_Omnifocus.scpt`. Or to your preferred folder.


## Using

![](https://github.com/Fulnir/zed_to_omnifocus/blob/main/zed_to_omnifocus.png)

### Applescript

In my case, I saved the Applesript in the Zed config folder `~/.config/zed/Comment_to_Omnifocus.scpt`


```applescript
on run argv

	set {tasktag, stem, deferplus, dueplus, symbol, tasknote, row, projectname, taskname} to {item 1, item 2, item 3, item 4, item 5, item 6, item 7, item 8, item 9} of argv


	tell application "System Events"
		count (every process whose name is "OmniFocus")
		if result < 1 then
			tell application "OmniFocus" to activate
		end if
	end tell


	tell front document of application "OmniFocus"
		set _defer to deferplus as number
		set _due to dueplus as number
		set _row to row as number
		set deferdate to ((current date) + (_defer * days))
		set duedate to ((current date) + (_defer * days) + (_due * days))
		try
			set theTag to (first flattened tag where its name is tasktag)
		on error
			set theTag to make new tag with properties {name:tasktag}
		end try
		set theProject to first flattened project where its name = projectname

		tell theProject
			make new task with properties {name:"➧" & stem & "➧" & symbol & "➧" & _row & "➧ " & taskname, note:tasknote, primary tag:theTag, defer date:deferdate, due date:duedate}

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

The date arguments:
- defer_days: The number of days for which the task is deferred.
- due_days: The number of days until the task is due.

The arguments send to the Applesript: `scrpt_path`, `omnifocus_tag`, `ZED_STEM`, `defer_days`, `due_days`, `ZED_SYMBOL`, `open_terninal_command`and the selected `comment_text`.

#### `tasks.json`

```json
[
  {
    "label": "Create an 📒ToDo OmniFocus task.",
    "command": "osascript \"$HOME/.config/zed/Comment_to_Omnifocus.scpt\"  \"📒Todo\"  \"$ZED_STEM\"  \"90\" \"180\" \"$ZED_SYMBOL\" \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\" \"$ZED_ROW\" \"My OmniFocus Project\"  \"📒 $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "no_focus",
    "hide": "on_success",
    "shell": "system"
  },
  {
    "label": "Create an 🩹FixMe OmniFocus task.",
    "command": "osascript \"$HOME/.config/zed/Comment_to_Omnifocus.scpt\"  \"🩹FixMe\"  \"$ZED_STEM\"  \"7\" \"30\"  \"$ZED_SYMBOL\"  \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\" \"$ZED_ROW\" \"My OmniFocus Project\"  \"🩹 $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "no_focus",
    "hide": "on_success",
    "shell": "system"
  },
  {
    "label": "Create an ⚠️Warning OmniFocus task.",
    "command": "osascript \"$HOME/.config/zed/Comment_to_Omnifocus.scpt\"  \"⚠️Warning\"  \"$ZED_STEM\"  \"30\" \"90\"  \"$ZED_SYMBOL\"  \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\" \"$ZED_ROW\" \"My OmniFocus Project\"  \"⚠️ $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "no_focus",
    "hide": "on_success",
    "shell": "system"
  },
  {
    "label": "Create an 🛑Error OmniFocus task.",
    "command": "osascript \"$HOME/.config/zed/Comment_to_Omnifocus.scpt\"  \"🛑Error\"  \"$ZED_STEM\"  \"7\" \"90\"  \"$ZED_SYMBOL\"  \"zed $ZED_FILE:$ZED_COLUMN:$ZED_ROW\" \"$ZED_ROW\" \"My OmniFocus Project\"  \"🛑 $ZED_SELECTED_TEXT\"  ",
    "tags": ["OmniFocus"],
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "no_focus",
    "hide": "on_success",
    "shell": "system"
  }
]
```

### Keymap

4 tasks are required. ⚠️ Press the `cmd` key when selecting the spawn task, otherwise the same arguments as forigen will be used for the next call.

#### `keymap.json`

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

A few more snippets for entering comments.

#### `your_snippets.json`

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
