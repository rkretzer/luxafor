JsOsaDAS1.001.00bplist00�Vscript_yfunction getJSON(path) {
	const fm = $.NSFileManager.defaultManager
	const data = fm.contentsAtPath($(path).stringByExpandingTildeInPath)
	const str = $.NSString.alloc.initWithDataEncoding(data, $.NSUTF8StringEncoding)
	return JSON.parse(ObjC.unwrap(str))
}

function run() {

	let focus = "No focus" // default
	const assert = getJSON("~/Library/DoNotDisturb/DB/Assertions.json").data[0].storeAssertionRecords
	const modecf = getJSON("~/Library/DoNotDisturb/DB/ModeConfigurations.json")
	const config = modecf.data[0].modeConfigurations

	if (assert) { // focus set manually

		const modeid = assert[0].assertionDetails.assertionDetailsModeIdentifier
		focus = config[modeid].mode.name

	} else { // focus set by trigger

		const date = new Date
		const now = date.getHours() * 60 + date.getMinutes()

		for (const modeid in config) {

			const triggers = config[modeid].triggers.triggers[0]
			if (triggers && triggers.enabledSetting == 2) {

				const start = triggers.timePeriodStartTimeHour * 60 + triggers.timePeriodStartTimeMinute
				const end = triggers.timePeriodEndTimeHour * 60 + triggers.timePeriodEndTimeMinute
				if (start < end) {
					if (now >= start && now < end) {
						focus = config[modeid].mode.name
					}
				} else if (start > end) { // includes midnight
					if (now >= start || now < end) {
						focus = config[modeid].mode.name
					}
				}
			}
		}
	}
	return focus
}
                              � jscr  ��ޭ