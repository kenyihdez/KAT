-- Relationship status Volunteers (06)
-- UPDATED 23Oct List of not import contacts
SET NOCOUNT ON
BEGIN
	DECLARE @PersonID				AS INT,
			@lastPersonID			AS INT,
			@iCount					AS INT = 0,
			@OfficerID				AS INT,
			@StartDate				AS DATE,
			@firstStartDate			AS DATE,
			@lastStartDate			AS DATE,
		    @EndDate				AS DATE,
		    @lastEndDate			AS DATE,
			@Status__c				AS NVARCHAR(50),
			@firstStatus__c			AS NVARCHAR(50),
			@lastStatus__c			AS NVARCHAR(50),
			@RelationStatusID		AS NVARCHAR(20),
			@lastRelationStatusID	AS NVARCHAR(20),
			@RelationshipID			AS NVARCHAR(20),
			@lastRelationshipID		AS NVARCHAR(20)

	-- Drops the temporary table if exists
	IF OBJECT_ID('tempdb..#tmpDummy') IS NOT NULL
		DROP TABLE #tmpDummy

	-- Creates a temporal table to storage the records
	CREATE TABLE #tmpDummy (
		StartOnDate			DATE,
		EndOnDate			DATE,
		Status__c			NVARCHAR(50),
		OfficerID			INT,
		RelationStatusID	NVARCHAR(20),
		RelationshipID		NVARCHAR(20),
		PersonID			INT
	)

	-- Cursor for Volunteer Relationship Status
	DECLARE db_cursor CURSOR FOR
		SELECT CAST(o.BeginDate AS DATE) AS StartOnDate, 
			   CASE o.InOffice WHEN 1 THEN NULL ELSE CAST(o.EndDate AS DATE) END AS EndOnDate, 
			   CASE 
					WHEN c.ChapterTypeCode = 'A' AND o.InOffice = 1 THEN 'Alumnae Chapter Volunteer' 
					WHEN c.ChapterTypeCode != 'A' AND o.InOffice = 1 THEN 'College Chapter Volunteer'
					WHEN c.ChapterTypeCode != 'A' AND o.InOffice != 1 THEN 'College Chapter Inactive Volunteer'
					WHEN c.ChapterTypeCode = 'A' AND o.InOffice != 1 THEN 'Alumnae Chapter Inactive Volunteer'
					END AS Status__c,
			   o.OfficerID,
			   'RSID' + CAST(o.OfficerID AS VARCHAR) + CAST(o.ChapterID AS VARCHAR) AS RelationStatusID, 
			   'V' + CAST(o.PersonID AS VARCHAR) + CAST(o.ChapterID AS VARCHAR) AS RelationshipID,
			   o.PersonID
		  FROM tblChapters c, tblOfficers o, tblOffices oft
		 WHERE c.ChapterID = o.ChapterID
		   AND o.OfficeID = oft.OfficeID
		   AND o.OfficeTypeID = 4
		   AND o.PersonID not in (382458,382459,382460,393437,393438,393441,393442,393443,414835,415646,415646,415724,415725,417546,423100,444474,7865,368557,217760,193860,158909,397929,397930,397931,397932,397933,397934,397935,397936,397937,397938,397939,397940,397941,397942,397943,397944,397945,397947,397948,397949,397950,397951,397952,397953,397954,397955,397956,397957,397958,397959,397960,397961,397962,397963,397964,397967,397968,397969,397970,397971,397972,397973,397974,397975,397976,397977,397978,397979,397980,397981,397982,397983,397984,397985,397986,397987,397988,397989,397990,397991,397992,397993,397994,397995,397996,397997,397998,397999,398000,398001,398002,398003,398004,398005,398006,398007,398008,398009,398010,398011,398012,398013,398014,398015,398016,398017,398018,398019,398020,398021,398022,398023,398024,398025,398026,398027,398028,398029,398030,398031,398032,398033,398034,398035,398036,398037,398038,398039,398040,398041,398042,398043,398044,398045,398046,398047,398048,398049,398050,398051,398052,398053,398054,398055,398056,398057,398058,398059,398060,398061,398062,398063,398064,398065,398066,398067,398068,398069,398070,398071,398072,398073,398074,398075,398076,398077,398078,398079,398080,398081,398082,398083,398084,398085,398086,398087,398088,398089,398090,398091,398092,398093,398094,398095,398096,398097,398098,398099,398100,398101,398102,398103,398104,398105,398106,398107,398108,398109,398110,398111,398112,398113,398114,398115,398116,398117,398118,398119,398120,398121,398122,398123,398124,398125,398126,398127,398128,398129,398130,398131,398132,398133,398134,398135,398136,398137,398138,398139,398140,398141,398142,398143,398144,398145,398146,398147,398148,398149,398150,398151,398152,398153,398154,398155,398156,398157,398158,398159,398160,398161,398162,398163,398164,398165,398166,398167,398168,398169,398170,398171,398172,398173,398174,398175,398176,398177,398178,398179,398180,398181,398182,398183,398184,398185,398186,398187,398188,398189,398190,398191,398192,398193,398194,398195,398196,398197,398198,398199,398200,398201,398202,398203,398204,398205,398206,398207,398208,398209,398210,398211,398212,398213,398214,398215,398216,398217,398218,398219,398220,398221,398222,398223,398224,398225,398226,398227,398228,398229,398230,398231,398232,398233,398234,398235,398236,398237,398238,398239,398240,398241,398242,398243,398244,398245,398246,398247,398248,398249,398250,398251,398252,398253,398254,398255,398256,398257,398258,398259,398260,398261,398262,398263,398264,398265,398266,398267,398268,398269,398270,398271,398272,398273,398274,398275,398276,398277,398278,398279,398280,398281,398282,398283,398284,398285,398286,398287,398288,398289,398290,398291,398292,398293,398294,398295,398296,398297,398298,398299,398300,398301,398302,398303,398304,398305,398306,398307,398308,398309,398310,398311,398312,398313,398314,398315,398316,398317,398318,398319,398320,398321,398322,398323,398324,398325,398326,398327,398328,398329,398330,398331,398332,398333,398334,398335,398336,398337,398338,398339,398340,398341,398342,398343,398344,398345,398346,398347,398348,398349,398350,398351,398352,398353,398354,398355,398356,398357,398358,398359,398360,398361,398362,398363,398364,398365,398366,398367,398368,398369,398370,398371,398372,398373,398374,398375,398376,398711,398712,400123,400124,400125,400195,400720,400721,400722,400723,400724,400725,402184,402185,405346,405347,405348,405795,405796,405797,406578,406676,410019,410289,410296,410297,410304,411637,414835,415335,415834,417049,419044,419095,419096,427192,427316,427317,427318,427319,427320,427321,427322,430597,434386,434387,434388,435818,435819,436402,436403,442089,442090,442147,442148,444316,444317,172916,185599,189459,189488,189495,189539,189546,189547,189549,189554,189624,189634,189649,189652,195371,196295,203290,207286,215013,217698,356865,367026,369519,390461,410309,426912,426913,174838,175721,185630,370245,156680,156899,159264,160693,160779,164346,166844,169404,169940,171893,172341,172440,173018,173019,173412,173660,175116,175471,176532,176597,176602,176613,176614,176849,178721,178724,178726,178728,178729,179280,180483,181186,181199,181249,189614,189621,205570)
   		 AND o.PersonID IN (209335,218046,218148,221069,221335,362854,369640,138502,138549,162273,182577,197263,197300,197323,396316,396318,396320,396321,396322,396323,396324,398517,399623,402172,402174,402238,402371,406356,406357,406358,406359,406360,406361,406362,406363,406364,415676,415677,415678,415679,415680,420804,420805,420806,420807,420808,420809,420814,420815,420816,420817,420818,420819,425084,425543,425544,425545,425546,425547,425548,430360,442012,442013,442014,442015,442016,138595,403262,408929,447539,217310,217311,217317,217318,217320,217321,217322,217323,217324,217325,217326,217327,217328,217329,217330,217377,217251,217252,217253,217255,220677,358858,358859,362855,367242,373172,373173,2600,129072,129156,129184,129207,129231,129268,142682,142693,142770,142801,383663,383664,383665,383666,383667,389284,389285,389311,389312,389313,389316,395457,395458,395459,395460,395461,395462,395463,395465,395467,395468,395469,395470,395471,395472,396557,396559,396560,396561,396562,396563,408008,408009,408010,408011,420864,420913,420914,420915,420916,420928,420929,443145,443146,443147,443148,443149)
		   AND oft.OfficeName in ('Advisory Board Chairman',
								  'Administrative Advisor',
								  'Operations Advisor',
								  'Risk Prevention Advisor',
								  'Ritual Advisor',
								  'Education Advisor',
								  'Scholarship Advisor',
								  'Finance Advisor',
								  'Facility Management Advisor',
								  'Recruitment Advisor',
								  'Panhellenic Advisor',
								  'Community Involvement Advisor',
								  'Marketing Advisor',
								  'At-Large Advisor',
								  'Staff Advisor',
								  'Fraternity/Sorority Advisor',
								  'Assisting District Director',
								  'Facility Corporation President',
								  'Facility Corporation Vice President',
								  'Facility Corporation Treasurer',
								  'Facility Corporation Secretary')
		ORDER BY 'V' + CAST(o.PersonID AS VARCHAR) + CAST(o.ChapterID AS VARCHAR), StartOnDate

	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @StartDate, @EndDate, @Status__c, @OFficerID, @RelationStatusID, @RelationshipID, @PersonID

	WHILE @@FETCH_STATUS = 0 BEGIN
		IF @RelationshipID != @lastRelationshipID AND ISNULL(@lastRelationshipID, '') != '' BEGIN-- The recordset has changed from one member to the other one
			SELECT @iCount = 0
			IF @firstStatus__c = 'Alumnae Chapter Volunteer' AND @lastStatus__c = 'Alumnae Chapter Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, NULL, 'Alumnae Chapter Active Volunteer', @OfficerID, @lastRelationStatusID, @lastRelationshipID, @lastPersonID)
			END

			IF @firstStatus__c = 'College Chapter Volunteer' AND @lastStatus__c = 'College Chapter Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, NULL, 'College Chapter Active Volunteer', @OfficerID, @lastRelationStatusID, @lastRelationshipID, @lastPersonID)
			END

			IF @firstStatus__c = 'Alumnae Chapter Volunteer' AND @lastStatus__c = 'Alumnae Chapter Inactive Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, @lastEndDate, 'Alumnae Chapter Volunteer', @OfficerID, @lastRelationStatusID + 'A', @lastRelationshipID, @lastPersonID)
					 
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@lastEndDate, @lastEndDate, 'Alumnae Chapter Inactive Volunteer', @OfficerID, @lastRelationStatusID + 'B', @lastRelationshipID, @lastPersonID)
			END

			IF @firstStatus__c = 'College Chapter Volunteer' AND @lastStatus__c = 'College Chapter Inactive Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, @lastEndDate, 'College Chapter Volunteer', @OfficerID, @lastRelationStatusID + 'A', @lastRelationshipID, @lastPersonID)
					 
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@lastEndDate, @lastEndDate, 'College Chapter Inactive Volunteer', @OfficerID, @lastRelationStatusID + 'B', @lastRelationshipID, @lastPersonID)
			END

			IF @firstStatus__c = 'Alumnae Chapter Inactive Volunteer' AND @lastStatus__c = 'Alumnae Chapter Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, NULL, 'Alumnae Chapter Volunteer', @OfficerID, @lastRelationStatusID, @lastRelationshipID, @lastPersonID)
			END

			IF @firstStatus__c = 'College Chapter Inactive Volunteer' AND @lastStatus__c = 'College Chapter Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, NULL, 'College Chapter Volunteer', @OfficerID, @lastRelationStatusID, @lastRelationshipID, @lastPersonID)
			END

			IF @firstStatus__c = 'Alumnae Chapter Inactive Volunteer' AND @lastStatus__c = 'Alumnae Chapter Inactive Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, @lastEndDate, 'Alumnae Chapter Volunteer', @OfficerID, @lastRelationStatusID + 'A', @lastRelationshipID, @lastPersonID)

				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@lastEndDate, @lastEndDate, 'Alumnae Chapter Inactive Volunteer', @OfficerID, @lastRelationStatusID + 'B', @lastRelationshipID, @lastPersonID)
			END

			IF @firstStatus__c = 'College Chapter Inactive Volunteer' AND @lastStatus__c = 'College Chapter Inactive Volunteer' BEGIN
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@firstStartDate, @lastEndDate, 'College Chapter Volunteer', @OfficerID, @lastRelationStatusID + 'A', @lastRelationshipID, @lastPersonID)

				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID)
					 VALUES (@lastEndDate, @lastEndDate, 'College Chapter Inactive Volunteer', @OfficerID, @lastRelationStatusID + 'B', @lastRelationshipID, @lastPersonID)
			END

		END
		
		SELECT @lastStartDate = @StartDate, @lastEndDate = @EndDate, @lastStatus__c = @Status__c, @lastRelationStatusID = @RelationStatusID, @lastRelationshipID = @RelationshipID, @lastPersonID = @PersonID

		SELECT @iCount = @iCount + 1
		IF @iCount = 1
			SELECT @firstStartDate = @StartDate, @firstStatus__c = @Status__c
	
		FETCH NEXT FROM db_cursor INTO @StartDate, @EndDate, @Status__c, @OfficerID, @RelationStatusID, @RelationshipID, @PersonID
	END -- While

	CLOSE db_cursor
	DEALLOCATE db_cursor
		
	SELECT StartOnDate, EndOnDate, Status__c, OfficerID, RelationStatusID, RelationshipID, PersonID
	  FROM #tmpDummy
	 ORDER BY RelationshipID, StartOnDate 
END