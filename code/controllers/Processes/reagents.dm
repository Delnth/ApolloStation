var/list/processing_reagents = list()

/datum/controller/process/reagents/setup()
	name = "reagents"
	schedule_interval = 30 // every third second

/datum/controller/process/reagents/doWork()
	for(var/datum/reagents/R in processing_reagents)
		R.process()
