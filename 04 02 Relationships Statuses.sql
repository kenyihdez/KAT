-- Relationship Statuses (02) 
-- UPDATED 23Oct List of not import contacts
-- This one is for chapter affiliations with the affiliation type = AFFIL
SET NOCOUNT ON
BEGIN -- Begin of the program
	-- Variables declaration
	DECLARE		@StartOnDate			DATE,
				@lastStartOnDate		DATE,
				@EndOnDate				DATE,
				@lastEndOnDate			DATE,
				@maxDate				DATE,
				@iCount					INT	= 0,
				@PersonID				INT,
				@lastPersonID			INT,
				@MembershipID			INT,
				@curID					INT,
				@lastcurID				INT,
				@Status__c				NVARCHAR(100) = NULL,
				@lastStatus__c			NVARCHAR(100) = NULL,
				@RelationStatusID		NVARCHAR(30),
				@lastRelationStatusID	NVARCHAR(30),
				@RelationshipID			NVARCHAR(30),
				@lastRelationshipID		NVARCHAR(30)

	-- Drops the temporary table if exists
	IF OBJECT_ID('tempdb..#tmpDummy') IS NOT NULL
		DROP TABLE #tmpDummy

	-- Creates a temporary table to store stage data
	CREATE TABLE #tmpDummy (
		StartOnDate		 DATE,
		EndOnDate		 DATE,
		Status__c		 NVARCHAR(100),
		MembershipID	 INT,
		RelationStatusID NVARCHAR(30),
		RelationshipID   NVARCHAR(30),
		PersonID		 INT,
		curID			 INT 
	 )

	DECLARE curAffAFFIL CURSOR FOR
	SELECT CASE WHEN h.StartOnDate < '2001-01-01' 
			THEN 
				CAST (CASE WHEN m.MembershipStatusOn > m.MembershipTypeOn THEN
					m.MembershipStatusOn
				ELSE
					m.MembershipTypeOn
				END AS DATE) 
				ELSE CAST(h.StartOnDate AS DATE) END AS StartOnDate, 
			CAST(h.EndOnDate AS DATE) AS EndOnDate,
			CASE sc.MembershipStatus + t.MembershipType
			WHEN 'Vol Resignation' + 'Ex-Alumnae' THEN 'Alumna' 
			WHEN 'In Good Standing' + 'Alumnae Init' THEN 'Alumna' 
			WHEN 'In Good Standing' + 'Alumnae' THEN 'Alumna' 
			WHEN 'In Good Standing' + 'Undergraduate' THEN 'Active'
			WHEN 'Alumnae' + 'Alumnae Init' THEN 'Alumnae Probation'
			WHEN 'Dormant' + 'Alumnae Init' THEN 'Alumna'
			WHEN 'Alumnae Probation' + 'Alumnae' THEN 'Alumnae Probation'
			WHEN 'Dormant' + 'Alumnae' THEN 'Alumna'
			WHEN 'Term Pending Disc' + 'Alumnae' THEN 'Alumna'
			WHEN 'Term Pending Fin' + 'Alumnae' THEN 'Alumna'
			WHEN 'Discretionary Term' + 'Ex-Alumnae' THEN 'Ex-Alumna'
			WHEN 'Financial Term' + 'Ex-Alumnae' THEN 'Ex-Alumna'
			WHEN 'Resigned' + 'Ex-Alumnae' THEN 'Ex-Alumna'
			WHEN 'Brand New Member' + 'New Member' THEN 'New Member'
			WHEN 'Init Reported' + 'New Member' THEN 'New Member'
			WHEN 'New Member' + 'New Member' THEN 'New Member'
			WHEN 'Never Initiated' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'XNM Displeased' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'XNM Money' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'XNM Other' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'XNM Time' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Inactive Fall' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Inactive M/G' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Inactive Medical' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Inactive Spring' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Inactive Winter Qtr' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Inactive Winter/Spring Qtr' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Inactive Year' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Invol Inactivity' + 'Undergraduate' THEN 'Involuntarily Inactive'
			WHEN 'Off Campus' + 'Undergraduate' THEN 'Abroad / Off Campus'
			WHEN 'Term Pending Disc' + 'Undergraduate' THEN 'Undergraduate - Termination Pending - Disciplinary'
			WHEN 'Term Pending Fin' + 'Undergraduate' THEN 'Undergraduate - Termination Pending - Financial'
			WHEN 'Unaffiliated Student' + 'Undergraduate' THEN 'Unaffiliated'
			WHEN 'Vol Inactivity (5yr)' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Discretionary Term' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Financial Term' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Resigned' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Scholastic Term' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Academics' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Displeased' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Fin' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Other Reason' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Pending' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Time' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Inactivity' + 'Undergraduate' THEN 'Involuntarily Inactive'
			--
			WHEN 'Discretionary Term' + 'Alumnae' THEN 'Ex-Alumna'
			WHEN 'Financial Term' + 'Alumnae' THEN 'Ex-Alumna'
			WHEN 'Alumnae Term' + 'Ex-Alumnae' THEN 'Ex-Alumna'
			WHEN 'In Good Standing' + 'Ex-Alumnae' THEN 'Ex-Alumna'
			WHEN 'Term Pending Fin' + 'Ex-Alumnae' THEN 'Ex-Alumna'
			WHEN 'Vol Resignation Displeased' + 'Ex-Alumnae' THEN 'Alumna'
			WHEN 'Vol Resignation Fin' + 'Ex-Alumnae' THEN 'Alumna'
			WHEN 'Vol Resignation Other Reason' + 'Ex-Alumnae' THEN 'Alumna'
			WHEN 'Brand New Member' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Vol Resignation Displeased' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Vol Resignation Fin' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Vol Resignation Other Reason' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'In Good Standing' + 'New Member' THEN 'New Member'
			WHEN 'Never Initiated' + 'New Member' THEN 'Ex-New Member'
			WHEN 'XNM Other' + 'New Member' THEN 'Ex-New Member'
			WHEN 'Discretionary Term' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Financial Term' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Resigned' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Academics' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Displeased' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Fin' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Other Reason' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Pending' + 'Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Vol Resignation Time' + 'Undergraduate' THEN 'Ex-Undergraduate'
			--
			WHEN 'Friend' + 'Alumnae' THEN 'Alumna'
			WHEN 'Inactive M/G' + 'Alumnae' THEN 'Alumna'
			WHEN 'Inactive Spring' + 'Alumnae' THEN 'Alumna'
			WHEN 'Inactive Year' + 'Alumnae' THEN 'Alumna'
			WHEN 'Invol Inactivity' + 'Alumnae' THEN 'Alumna'
			WHEN 'Never Initiated' + 'Alumnae' THEN 'Active'
			WHEN 'Off Campus' + 'Alumnae' THEN 'Alumna'
			WHEN 'Parent' + 'Alumnae' THEN 'Alumna'
			WHEN 'Resigned' + 'Alumnae' THEN 'Ex-Alumna'
			WHEN 'Unaffiliated Student' + 'Alumnae' THEN 'Alumna'
			WHEN 'Undergrad Incomplete' + 'Alumnae' THEN 'Alumna'
			WHEN 'Vol Inactivity' + 'Alumnae' THEN 'Alumna'
			WHEN 'Vol Inactivity (5yr)' + 'Alumnae' THEN 'Alumna'
			WHEN 'Vol Resignation' + 'Alumnae' THEN 'Alumna'
			WHEN 'Vol Resignation Pending' + 'Alumnae' THEN 'Ex-Undergraduate'
			WHEN 'Friend' + 'Alumnae Init' THEN 'Alumna New Member'
			WHEN 'New Member' + 'Alumnae Init' THEN 'Alumna New Member'
			WHEN 'Discretionary Term' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Dormant' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Financial Term' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'In Good Standing' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Init Reported' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Invol Inactivity' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'New Member' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Term Pending Fin' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Vol Inactivity' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Vol Resignation' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Web Input New Member' + 'Ex-New Member' THEN 'Ex-New Member'
			WHEN 'Alumnae Term' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Dormant' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'In Good Standing' + 'Ex-Undergraduate' THEN 'Active'
			WHEN 'Invol Inactivity' + 'Ex-Undergraduate' THEN 'Involuntarily Inactive'
			WHEN 'Never Initiated' + 'Ex-Undergraduate' THEN 'Ex-New Member'
			WHEN 'Term Pending Fin' + 'Ex-Undergraduate' THEN 'Undergraduate - Termination Pending - Financial'
			WHEN 'Unaffiliated Student' + 'Ex-Undergraduate' THEN 'Unaffiliated'
			WHEN 'Undergrad Incomplete' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'XNM Time' + 'Ex-Undergraduate' THEN 'Ex-Undergraduate'
			WHEN 'Dormant' + 'New Member' THEN 'New Member'
			WHEN 'Financial Term' + 'New Member' THEN 'Ex-New Member'
			WHEN 'Inactive Fall' + 'New Member' THEN 'New Member'
			WHEN 'Invol Inactivity' + 'New Member' THEN 'Involuntarily Inactive'
			WHEN 'Off Campus' + 'New Member' THEN 'Abroad / Off Campus'
			WHEN 'Resigned' + 'New Member' THEN 'Ex-New Member'
			WHEN 'Term Pending Disc' + 'New Member' THEN 'New Member'
			WHEN 'Term Pending Fin' + 'New Member' THEN 'New Member'
			WHEN 'Unaffiliated Student' + 'New Member' THEN 'New Member'
			WHEN 'Undergrad Incomplete' + 'New Member' THEN 'New Member'
			WHEN 'Vol Inactivity' + 'New Member' THEN 'Involuntarily Inactive'
			WHEN 'Vol Resignation' + 'New Member' THEN 'Ex-New Member'
			WHEN 'Web Input New Member' + 'New Member' THEN 'New Member'
			WHEN 'Alumnae Probation' + 'Undergraduate' THEN 'Alumnae Probation'
			WHEN 'Brand New Member' + 'Undergraduate' THEN 'Active'
			WHEN 'Dormant' + 'Undergraduate' THEN 'Active'
			WHEN 'Friend' + 'Undergraduate' THEN 'Active'
			WHEN 'Init Reported' + 'Undergraduate' THEN 'New Member'
			WHEN 'Never Initiated' + 'Undergraduate' THEN 'Active'
			WHEN 'New Member' + 'Undergraduate' THEN 'Active'
			WHEN 'Undergrad Incomplete' + 'Undergraduate' THEN 'Alumna'
			WHEN 'Vol Inactivity' + 'Undergraduate' THEN 'Inactive'
			WHEN 'Web Input New Member' + 'Undergraduate' THEN 'Active'
			END AS Status__c,
			m.MembershipID,
			'RSID' + CAST(h.MemHistoryID AS varchar) AS RelationStatusID, -- + CAST(a.AffiliationID AS varchar) , 
			'A' + CAST(m.PersonID AS varchar) + CAST(a.ChapterID AS varchar) AS RelationshipID, 
			m.PersonID
		FROM tblMemberships m, tblMembershipHistory h, tlkMembershipStatusCodes sc, 
			 tlkMembershipTypes t, tblChapterAffiliations a
	   WHERE m.MembershipID = h.MembershipID 
		 AND m.MembershipID = a.MembershipID
		 AND h.MembershipStatusCode = sc.MembershipStatusCode 
		 AND h.MembershipTypeCode = t.MembershipTypeCode
		 AND a.AffiliationTypeCode = 'AFFIL'
		 AND sc.MembershipStatus + t.MembershipType NOT IN ('Brand New MemberNew Member', 'Init ReportedNew Member', 'New MemberNew Member') 
		 AND m.PersonID not in (382458,382459,382460,393437,393438,393441,393442,393443,414835,415646,415646,415724,415725,417546,423100,444474,7865,368557,217760,193860,158909,397929,397930,397931,397932,397933,397934,397935,397936,397937,397938,397939,397940,397941,397942,397943,397944,397945,397947,397948,397949,397950,397951,397952,397953,397954,397955,397956,397957,397958,397959,397960,397961,397962,397963,397964,397967,397968,397969,397970,397971,397972,397973,397974,397975,397976,397977,397978,397979,397980,397981,397982,397983,397984,397985,397986,397987,397988,397989,397990,397991,397992,397993,397994,397995,397996,397997,397998,397999,398000,398001,398002,398003,398004,398005,398006,398007,398008,398009,398010,398011,398012,398013,398014,398015,398016,398017,398018,398019,398020,398021,398022,398023,398024,398025,398026,398027,398028,398029,398030,398031,398032,398033,398034,398035,398036,398037,398038,398039,398040,398041,398042,398043,398044,398045,398046,398047,398048,398049,398050,398051,398052,398053,398054,398055,398056,398057,398058,398059,398060,398061,398062,398063,398064,398065,398066,398067,398068,398069,398070,398071,398072,398073,398074,398075,398076,398077,398078,398079,398080,398081,398082,398083,398084,398085,398086,398087,398088,398089,398090,398091,398092,398093,398094,398095,398096,398097,398098,398099,398100,398101,398102,398103,398104,398105,398106,398107,398108,398109,398110,398111,398112,398113,398114,398115,398116,398117,398118,398119,398120,398121,398122,398123,398124,398125,398126,398127,398128,398129,398130,398131,398132,398133,398134,398135,398136,398137,398138,398139,398140,398141,398142,398143,398144,398145,398146,398147,398148,398149,398150,398151,398152,398153,398154,398155,398156,398157,398158,398159,398160,398161,398162,398163,398164,398165,398166,398167,398168,398169,398170,398171,398172,398173,398174,398175,398176,398177,398178,398179,398180,398181,398182,398183,398184,398185,398186,398187,398188,398189,398190,398191,398192,398193,398194,398195,398196,398197,398198,398199,398200,398201,398202,398203,398204,398205,398206,398207,398208,398209,398210,398211,398212,398213,398214,398215,398216,398217,398218,398219,398220,398221,398222,398223,398224,398225,398226,398227,398228,398229,398230,398231,398232,398233,398234,398235,398236,398237,398238,398239,398240,398241,398242,398243,398244,398245,398246,398247,398248,398249,398250,398251,398252,398253,398254,398255,398256,398257,398258,398259,398260,398261,398262,398263,398264,398265,398266,398267,398268,398269,398270,398271,398272,398273,398274,398275,398276,398277,398278,398279,398280,398281,398282,398283,398284,398285,398286,398287,398288,398289,398290,398291,398292,398293,398294,398295,398296,398297,398298,398299,398300,398301,398302,398303,398304,398305,398306,398307,398308,398309,398310,398311,398312,398313,398314,398315,398316,398317,398318,398319,398320,398321,398322,398323,398324,398325,398326,398327,398328,398329,398330,398331,398332,398333,398334,398335,398336,398337,398338,398339,398340,398341,398342,398343,398344,398345,398346,398347,398348,398349,398350,398351,398352,398353,398354,398355,398356,398357,398358,398359,398360,398361,398362,398363,398364,398365,398366,398367,398368,398369,398370,398371,398372,398373,398374,398375,398376,398711,398712,400123,400124,400125,400195,400720,400721,400722,400723,400724,400725,402184,402185,405346,405347,405348,405795,405796,405797,406578,406676,410019,410289,410296,410297,410304,411637,414835,415335,415834,417049,419044,419095,419096,427192,427316,427317,427318,427319,427320,427321,427322,430597,434386,434387,434388,435818,435819,436402,436403,442089,442090,442147,442148,444316,444317,172916,185599,189459,189488,189495,189539,189546,189547,189549,189554,189624,189634,189649,189652,195371,196295,203290,207286,215013,217698,356865,367026,369519,390461,410309,426912,426913,174838,175721,185630,370245,156680,156899,159264,160693,160779,164346,166844,169404,169940,171893,172341,172440,173018,173019,173412,173660,175116,175471,176532,176597,176602,176613,176614,176849,178721,178724,178726,178728,178729,179280,180483,181186,181199,181249,189614,189621,205570)
	   ORDER BY m.PersonID, a.ChapterID, StartOnDate, EndOnDate

	DECLARE curTmp CURSOR FOR
	 SELECT PersonID, StartOnDate, EndOnDate, curID
	   FROM #tmpDummy
	  ORDER BY PersonID, StartOnDate 
	
	 OPEN curAffAFFIL
	 FETCH NEXT FROM curAffAFFIL INTO @StartOnDate, @EndOnDate, @Status__c, @MembershipID, @RelationStatusID, @RelationshipID, @PersonID

	 WHILE @@FETCH_STATUS = 0 BEGIN -- The cursor has records
		IF @Status__c IS NOT NULL BEGIN
			SELECT @iCount = @iCount + 1
	
			IF ISNULL(@lastStatus__c, ' ') != @Status__c OR @lastStatus__c IS NULL BEGIN -- Inserts a new record because the status has changed
				INSERT INTO #tmpDummy (StartOnDate, EndOnDate, Status__c, MembershipID, RelationStatusID, RelationshipID, PersonID, curID)
					 VALUES (@StartOnDate, @EndOnDate, @Status__c, @MembershipID, @RelationStatusID, @RelationshipID, @PersonID, @iCount)

				SELECT @lastRelationStatusID = @RelationStatusID
			END
			ELSE BEGIN
				SELECT @maxDate = MAX(EndOnDate)
				  FROM #tmpDummy
				 WHERE RelationshipID = @RelationshipID
				   AND Status__c = @Status__c
				  
				UPDATE #tmpDummy SET EndOnDate = @EndOnDate -- Updates the record to extend the range
				 WHERE RelationshipID = @RelationshipID
				   AND Status__c = @Status__c
				   AND EndOnDate = @maxDate
			END 
						
			IF @RelationshipID != @lastRelationshipID BEGIN-- It means we have change the person ID, this is a new person
				SELECT @maxDate = MAX(EndOnDate)
				  FROM #tmpDummy
				 WHERE RelationshipID = @lastRelationshipID
				
				UPDATE #tmpDummy SET EndOnDate = NULL 
				 WHERE RelationshipID = @lastRelationshipID
				   AND EndOnDate = @maxDate
				   AND Status__c = @lastStatus__c
			END

			SELECT @lastStatus__c = @Status__c, @lastRelationshipID = @RelationshipID 
		END
		FETCH NEXT FROM curAffAFFIL INTO @StartOnDate, @EndOnDate, @Status__c, @MembershipID, @RelationStatusID, @RelationshipID, @PersonID
	END -- While

	CLOSE curAffAFFIL
	DEALLOCATE curAffAFFIL

	-- For the last record
	UPDATE #tmpDummy SET EndOnDate = NULL
	 WHERE RelationStatusID = @lastRelationStatusID

	-- #2) Status begin date can't be equal to the end date unless its a terminal status
	UPDATE #tmpDummy SET EndOnDate = DATEADD(dd, 1, EndOnDate)
	 WHERE Status__c NOT IN ('Ex-New Member', 'College Chapter Inactive Volunteer', 'Alumnae Chapter Inactive Volunteer', 'Ended Membership')
	   AND EndOnDate = StartOnDate
	
	-- #4) Terminal status begin date must be equal to the end date.
   	UPDATE #tmpDummy SET EndOnDate = StartOnDate
	 WHERE Status__c IN ('Ex-New Member', 'College Chapter Inactive Volunteer', 'Alumnae Chapter Inactive Volunteer', 'Ended Membership')

	-- #3) X cases had an End Date > today. Suggestion is we set the End Date value to NULL. Any issues?
   	UPDATE #tmpDummy SET EndOnDate = NULL
	 WHERE EndOnDate >= GETDATE()

	-- #5 Overlaping dates
	OPEN curTmp
	FETCH NEXT FROM curTmp INTO @PersonID, @StartOnDate, @EndOnDate, @curID

	WHILE @@FETCH_STATUS = 0 BEGIN
		IF @RelationStatusID = @lastRelationStatusID
			IF @lastEndOnDate > @StartOnDate
				UPDATE #tmpDummy SET EndOnDate = @StartOnDate
				 WHERE curID = @lastCurID

		SELECT @lastRelationStatusID = @RelationStatusID, @lastStartOnDate = @StartOnDate, @lastEndOnDate = @EndOnDate, @lastCurID = @curID
		FETCH NEXT FROM curTmp INTO @RelationStatusID, @StartOnDate, @EndOnDate, @curID
	END --WHILE 

	CLOSE curTmp
	DEALLOCATE curTmp

	-- Select the list of records we have created
	SELECT StartOnDate, EndOnDate, Status__c, RelationStatusID, RelationshipID, PersonID
	  FROM #tmpDummy
	 ORDER BY RelationshipID, StartOnDate, EndOnDate
END -- End of the program
