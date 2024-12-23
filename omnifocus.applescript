on run argv

	set {tasktag, stem, deferplus, dueplus, symbol, tasknote, taskname} to {item 1, item 2, item 3, item 4, item 5, item 6, item 7} of argv


	tell application "System Events"
		count (every process whose name is "OmniFocus")
		if result < 1 then
			tell application "OmniFocus" to activate
		end if
	end tell


	tell front document of application "OmniFocus"
		set _defer to deferplus as number
		set _due to dueplus as number
		set deferdate to ((current date) + (_defer * days))
		set duedate to ((current date) + (_defer * days) + (_due * days))
		try
			set theTag to (first flattened tag where its name is tasktag)
		on error
			set theTag to make new tag with properties {name:tasktag}
		end try
		set theProject to first flattened project where its name = "View of Things"

		tell theProject
			make new task with properties {name:stem & ":" & symbol & ": " & taskname, note:tasknote, primary tag:theTag, defer date:deferdate, due date:duedate}

		end tell
	end tell
end run
