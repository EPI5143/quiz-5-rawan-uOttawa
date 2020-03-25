****************************************

EPI5143 Winter 2020 - Quiz 5
Student: Rizwan Awan (6850687)

****************************************;

libname classdat "/folders/myfolders/class_data";
libname quiz5 "/folders/myfolders/work_folder/data";

data quiz5.spine;
	set classdat.NhrAbstracts;
	if year(datepart(hraAdmDtm)) in (2003,2004) then output;
		else delete;
	run;
*Created spine dataset from NhrAbstracts;
*Kept only only admissions between Jan 1 2003 and Dec 31 2004;

proc sort data=quiz5.spine nodupkey;
	by hraEncWID;
	run;
*Sorted spine dataset by hraEncWID and removed duplicates;
*Spine dataset has 2230 unique observations;

proc sort data=classdat.nhrdiagnosis out=quiz5.diagnosis;
	by hdgHraEncWID;
	run;
*Created duplicate dataset of NhrDiagnosis;
*Sorted by hdgHraEncWID, dataset has 113083 rows;

data quiz5.diabetes;
	set quiz5.diagnosis;
		by hdgHraEncWID;
	if first.hdgHraEncWID then DM=0;
	if hdgcd in:('250' 'E11' 'E10') then DM=1;
	if last.hdgHraEncWID then output;
	retain DM;
	run;
*Created diabetes dataset with variable 'DM' to flag diabetes codes;
*Flattened file, diabaetes dataset has 32844 unique observations;

data quiz5.linked;
	merge
		quiz5.spine (in=a)
		quiz5.diabetes (in=b rename=(hdgHraEncWID=hraEncWID));
	if DM=. then DM=0;
	by hraEncWID;
	if a;
	run;
*Left-joined spine and diabetes dataset by encounter ID;
*Converted all missing DM values to DM=0;

proc freq data=quiz5.linked;
	table DM;
	run;
*Created frequency table for linked dataset;


****************************************

RESULT:	The frequency of diabetes diagnoses between January 1 2003
		and December 31 2004 is 3.72%, with 83 encounters recorded
		with a diabetes diagnositic code, out of a total of 2230
		unique encounters in that time frame.

DM	Frequency	Percent		Cumulative Frequency	Cumulative Percent
0	2147		96.28		2147					96.28
1	83			3.72		2230					100.00

****************************************;