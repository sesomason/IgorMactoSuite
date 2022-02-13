#pragma TextEncoding = "Shift_JIS"
#pragma rtGlobals=1		// Use modern global access method.
#include <Image Line Profile>
#include <Image Range Adjust>



//  Script to load MBS-A1 and Scienta-omicrion data
//  written in Igor 7.08 (64 bit)
//  
//  Seigo Soiuma,    Tohoku University  
//
//  ver 1.3.0.1  adapted to krx data for 2d   (Jun 16, 2020)
//  				 A big change in data folder, global variables, and function names
//					 for DataShow panel.
//					Naming for all functions and macros has been changed for ease to find them
//	 ver 1.3.0.2  data folder, global variables, and function names ahs been changed for graphtable and IgorOpen
//  ver 1.3.0.3  data folder, global variables, and function names ahs been changed for LookWave
//  ver 1.3.0.4  error in previewing of old-type A1 data is fixed
//					 "done" is added to DataOpen panel
//					 Dataload becomes possible if graphtable is not been activated
//	ver 1.3.0.4  Spin matrix of krx format (**S.krx) is able to be loaded to N x 4 size matrix
// ver 1.3.0.5  maybe minor change
// ver 1.3.0.6  size of MNList is increased to 5,000 to load a big data of micro ARPES
//					  DATAShow adapys to loadin of ibw file
//					(2020/11/10)  bug fixed for binary data loading
// ver 1.3.0.7  adapted to 64bit mode pf krx format. both of 32/64 data can be loaded.
// ver 1.3.0.8  adapted to 64bit mode pf krx format. for spin matrix 
//
// ver 1.3.0.10  enable to load old type of A1 txt file  (DO_DtShw_A1txt2D)
////////////////////  DataOpen Panel/////////////////////

Window DataOpen() : Panel
	PauseUpdate; Silent 1		// building window...
	DO_DataOpen_Reset()
	NewPanel /W=(479,88,706,137)
	ModifyPanel cbRGB=(57346,65535,49151)
	Button DO_DatOp_button,pos={6.00,3.00},size={72.00,20.00},proc=DO_botton_DataOpen,title="DataOpen"
	Button DO_IgrOp_button,pos={83.00,3.00},size={72.00,20.00},proc=DO_button_IgorOpen,title="IgorOpen"
	Button DO_GrTab_button,pos={6.00,26.00},size={73.00,20.00},proc=DO_button_GraphTable,title="graphtable"
	Button DO_GrTab_button,fSize=12
	Button DO_LkWav_button,pos={83.00,26.00},size={72.00,20.00},proc=DO_button_LookWave,title="LookWave"
	Button DO_ImPrf_button,pos={158.00,28.00},size={22.00,16.00},proc=DO_button_ImageProf,title="Prf"
	Button DO_ImPrf_button,fSize=7,fColor=(16385,65535,65535)
	Button DO_ImRng_button,pos={158.00,5.00},size={22.00,16.00},proc=DO_button_ImageRange,title="Rng"
	Button DO_ImRng_button,fSize=7,fColor=(16385,65535,65535)
	Button DO_Lbl_button,pos={181.00,5.00},size={22.00,16.00},proc=DO_button_Labeling,title="lab"
	Button DO_Lbl_button,fSize=7,fColor=(16385,65535,65535)
	Button DO_DOreset_button,pos={182.00,28.00},size={22.00,16.00},proc=DO_button_DOreset,title="Rcv"
	Button DO_DOreset_button,fSize=7,fColor=(65535,49157,16385)
	Button DO_done_button,pos={205.00,4.00},size={20.00,16.00},proc=DO_button_done,title="dn"
	Button DO_done_button,fSize=8,fColor=(65535,0,0)
EndMacro

Function DO_FolderMake()
	DFREF dfr = root:DataOpenF
	if (DataFolderRefStatus(dfr) ==0)
	NewDataFolder/O root:DataOpenF
	endif
End

Function DO_button_done(ctrlName) : ButtonControl
	String ctrlName

	Dowindow/K DataOpen
	
End


Function DO_botton_DataOpen(ctrlName) : ButtonControl 
	String ctrlName
	
	Dowindow  DataShow
	if (V_flag==0)
			Execute "DataShow()" 
	endif
	Dowindow/F  DataShow
//	Execute  "SetUPDataLoad()"
	
End

Function DO_button_IgorOpen(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow  DataShowIGOR
	if (V_flag==0)
		Execute "DataShowIGOR()" 
	endif
	Dowindow/F DataShowIGOR
//	Execute  "DO_Igr_SetUPDataLoadIGOR()"

End

Function DO_GraT_ResizeGraphTable()
	String WList, Wname
	Wave/T X_base, Y_base
	WList = "X_base;Last_Wave;Offset_Wave;Bias_Wave;Angle;Info_Wave;Y_base;X_start_Wave;Start_Wave;memo;"

	Variable length, maxlength=0
	Variable ii=0
		Do
			Wname = Stringfromlist(ii,WList)
			if (waveexists($WName)==0)
				return -1
			endif
			length = dimsize($Wname, 0)
			if (length>=maxlength)
				maxlength = length
			endif	
			ii+=1
		while (ii<10)
		
		variable  sn_xbase, sn_ybase
		sn_xbase = dimsize(x_base, 0)
		sn_ybase = dimsize(y_base, 0)
		
		 ii=0
		 Do
			Wname = Stringfromlist(ii,WList)
			Redimension/N=(maxlength) $Wname
			ii+=1
		while (ii<10)
			
		X_base[sn_xbase, ]="xwave"
		Y_base[sn_ybase, ]="wave"	
End


Function DO_GraT_CreateWaves()
wave/T Info_Wave, X_base, Y_base, memo
wave Angle, X_start_Wave, Start_Wave, Last_Wave, Offset_Wave, Bias_Wave

	if (waveexists(Info_wave)==0)
			Make/N=50/T/O  Info_Wave
		endif
		if (waveexists(X_base)==0)
			Make/N=50/T/O  X_base
			X_base = "xwave"
		endif
		if (waveexists(Y_base)==0)
			Make/N=50/T/O  Y_base
			Y_base = "wave"
		endif
		if (waveexists(memo)==0)
			Make/N=50/T/O  memo
		endif
		if (waveexists(Angle)==0)
			Make/N=50/O  Angle
		endif
		if (waveexists(X_start_Wave)==0)
			Make/N=50/O  X_start_Wave
		endif
		if (waveexists(Start_Wave)==0)
			Make/N=50/O  Start_Wave
		endif
		if (waveexists(Last_Wave)==0)
			Make/N=50/O  Last_Wave
		endif
		if (waveexists(Offset_Wave)==0)
			Make/N=50/O  Offset_Wave
		endif
		if (waveexists(Bias_Wave)==0)
			Make/N=50/O  Bias_Wave
		endif
		
End


Function DO_GraT_CreateGraphTable()
wave/T Info_Wave, X_base, Y_base, memo
wave Angle, X_start_Wave, Start_Wave, Last_Wave, Offset_Wave, Bias_Wave

	Dowindow GraphTable
	if (V_flag==0)
	
	DO_GraT_CreateWaves()
	
	Edit/N=GraphTable/W=(20,44,750,150)  Info_Wave, Angle, X_base, Y_base, X_start_Wave, Start_Wave, Last_Wave, Offset_Wave, Bias_Wave, memo
	ModifyTable format(Point)=1,width(Point)=70, width(Info_Wave)=90,width(Angle)=50
	ModifyTable width(X_base)=50,width(Y_base)=50,width(X_start_Wave)=50,width(Start_Wave)=50
	ModifyTable width(Last_Wave)=50,width(Offset_Wave)=45,width(Bias_Wave)=45,width(memo)=150
	
	endif
	Dowindow/F GraphTable

End 


Function DO_button_GraphTable(ctrlName) : ButtonControl
	String ctrlName
	
	DO_GraT_CreateGraphTable()
	DO_GraT_ResizeGraphTable()
	
End


Function DO_button_LookWave(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow  WavesShow
	if (V_flag==0)
			Execute "WavesShow()" 
	endif
	Dowindow/F  WavesShow
	
End



Function DO_button_ImageRange(ctrlName) : ButtonControl
	String ctrlName

	WMCreateImageRangeGraph();
	
End

Function DO_button_ImageProf(ctrlName) : ButtonControl
	String ctrlName

	WMCreateImageLineProfileGraph();

End

Function DO_button_Labeling(ctrlName) : ButtonControl
	String ctrlName

	Execute "DO_ShowW_Auto_Labelmaker()"

End


Function DO_button_DOreset(ctrlName) : ButtonControl
	String ctrlName

	Execute "DO_DataOpen_Reset()" 
	
End



Macro DO_DataOpen_Reset()
	
	DO_DtShw_SetUPDataLoad()
	DO_ShwW_SetupShowM()
	DO_Igr_SetUPDataLoadIGOR()
	DO_GraT_CreateWaves()

Endmacro


////////////////////  Scrpipts for DataShow  panel  /////////////////////
//     convert 2D arpes data (E vs k) to igor matrix 
//      SES(pxt,pxp), A1 (txt,mot,krx)　

Window DataShow() 
	PauseUpdate; Silent 1		// building window...

	DO_DtShw_SetUPDataLoad()
	Display /W=(844,127,1286,446)
	AppendImage :DataLoadFolder:showM
	ModifyImage showM ctab= {*,*,Terrain,0}
	ModifyGraph mirror=2
	ControlBar 57
	SetVariable DS_filepath_setvar,pos={17.00,5.00},size={318.00,13.00},proc=DO_DtShw_setvar_filepath,title=" "
	SetVariable DS_filepath_setvar,font="Helvetica"
	SetVariable DS_filepath_setvar,value= root:DataLoadFolder:GS_folderpath1
	Button DS_pathset_button,pos={343.00,4.00},size={43.00,16.00},proc=DO_DtShw_button_pathset,title="path"
	Button DS_pathset_button,font="Helvetica",fSize=10,fColor=(32768,65535,49386)
	SetVariable DS_setdataN_setvar,pos={16.00,24.00},size={54.00,16.00},proc=DO_DtShw_setvar_SetdataN,title=" "
	SetVariable DS_setdataN_setvar,font="Helvetica",fSize=12
	SetVariable DS_setdataN_setvar,value= root:DataLoadFolder:GV_datanum
	SetVariable DS_finename_setvar,pos={102.00,22.00},size={109.00,14.00},proc=DO_DtShw_setvar_finename,title=" "
	SetVariable DS_finename_setvar,value= root:DataLoadFolder:GS_dataname
	Button DS_dataload_button,pos={214.00,22.00},size={40.00,16.00},proc=DO_DtShw_button_DataLoad,title="load"
	Button DS_dataload_button,font="Helvetica",fSize=10,fColor=(32792,65535,1)
	SetVariable DS_DatNamHead_setvar,pos={259.00,23.00},size={41.00,14.00},title=" "
	SetVariable DS_DatNamHead_setvar,valueBackColor=(32792,65535,1)
	SetVariable DS_DatNamHead_setvar,value= root:DataLoadFolder:LoadMatHead
	Button DS_MulDataLoad_button,pos={305.00,22.00},size={43.00,16.00},proc=DO_DtShw_button_DataLoadMulti,title="m.load"
	Button DS_MulDataLoad_button,fSize=10,fColor=(65535,43690,0)
	Button DS_UpFolder_button,pos={71.00,22.00},size={30.00,16.00},proc=DO_DtShw_button_UpFolder,title="Up"
	Button DS_UpFolder_button,fSize=10,fColor=(0,65535,0)
	Button DS_done_button,pos={351.00,22.00},size={33.00,16.00},proc=DO_DtShw_button_done,title="done"
	Button DS_done_button,fSize=10,fColor=(65535,16385,16385)
	CheckBox DS_NoiseRed_check,pos={19.00,40.00},size={29.00,16.00},proc=DO_DtShw_check_NoiseRed,title="NR"
	CheckBox DS_NoiseRed_check,variable= root:DataLoadFolder:DataOpen_flag_NR
	SetVariable DS_NRstartP_setvar,pos={56.00,42.00},size={50.00,13.00},proc=DO_DtShw_setvar_NormChange,title="sp"
	SetVariable DS_NRstartP_setvar,font="Helvetica"
	SetVariable DS_NRstartP_setvar,value= root:DataLoadFolder:DataOpen_NR_sp
	SetVariable DS_NRendP_setvar,pos={104.00,42.00},size={59.00,13.00},proc=DO_DtShw_setvar_NormChange,title="ep"
	SetVariable DS_NRendP_setvar,font="Helvetica"
	SetVariable DS_NRendP_setvar,value= root:DataLoadFolder:DataOpen_NR_ep
	CheckBox DS_Combine_check,pos={168.00,40.00},size={36.00,16.00},proc=DO_DtShw_check_Combine,title="Cmb"
	CheckBox DS_Combine_check,font="Helvetica"
	CheckBox DS_Combine_check,variable= root:DataLoadFolder:DataOpen_flag_comb
	SetVariable DS_CMBstartP_setvar,pos={211.00,42.00},size={42.00,13.00},proc=DO_DtShw_setvar_NormChange,title="cx"
	SetVariable DS_CMBstartP_setvar,font="Helvetica"
	SetVariable DS_CMBstartP_setvar,value= root:DataLoadFolder:DataOpen_comb_x
	SetVariable DS_CMBendP_setvar,pos={253.00,42.00},size={41.00,13.00},proc=DO_DtShw_setvar_NormChange,title="cy"
	SetVariable DS_CMBendP_setvar,font="Helvetica"
	SetVariable DS_CMBendP_setvar,value= root:DataLoadFolder:DataOpen_comb_y
	CheckBox DS_Normalize_check,pos={303.00,41.00},size={34.00,16.00},proc=DO_DtShw_check_Normalize,title="Nrm"
	CheckBox DS_Normalize_check,font="Helvetica"
	CheckBox DS_Normalize_check,variable= root:DataLoadFolder:DataOpen_flag_Norm
	SetVariable DS_NRMstartP_setvar,pos={344.00,42.00},size={42.00,13.00},proc=DO_DtShw_setvar_NormChange,title="s"
	SetVariable DS_NRMstartP_setvar,font="Helvetica"
	SetVariable DS_NRMstartP_setvar,value= root:DataLoadFolder:DataOpen_Norm_sr
	SetVariable DS_NRMendP_setvar,pos={385.00,42.00},size={46.00,13.00},proc=DO_DtShw_setvar_NormChange,title="e"
	SetVariable DS_NRMendP_setvar,font="Helvetica"
	SetVariable DS_NRMendP_setvar,value= root:DataLoadFolder:DataOpen_Norm_er
	Button DS_SESinfo_button,pos={391.00,4.00},size={40.00,16.00},proc=DO_DtShw_button_SESinfo,title="SESinf"
	Button DS_SESinfo_button,font="Helvetica",fSize=10,fColor=(32769,65535,32768)
	SetVariable DS_IgrDatNum_setvar,pos={387.00,24.00},size={53.00,13.00},proc=DO_DtShw_setvar_IgrDatNum,title=" ig"
	SetVariable DS_IgrDatNum_setvar,font="Helvetica",fSize=9
	SetVariable DS_IgrDatNum_setvar,limits={0,255,1},value= root:DataLoadFolder:DataOpen_SES_IgorMultiData
	
//	Dowindow/C Datashow
EndMacro




Function DO_DtShw_SetUPDataLoad()
		
	if (DataFolderRefStatus(dfr) ==0)
		NewDataFolder/O root:DataLoadFolder
	endif
	DFREF dfr = root:DataLoadFolder
	
	
	// path for folder
	String/G dfr:GS_folderpath1
	// number of file in folder to load
	Variable/G dfr:GV_datanum
	// name of file in folder to load
	String/G dfr:GS_dataname
	
	make/d/o/N=(501,501) dfr:showM // matirx to display in Data Show window
	SetScale/P x 0,0.01,"", dfr:showM
	SetScale/P y 0,0.01,"", dfr:showM
	
	wave shm = dfr:showM
	shm=100000*(sin(pi*(p/500)*10)+1)*(sin(pi*(q/500)*10)+1)
	duplicate/o shm dfr:storeM0 // matirx to store the original data of file
	duplicate/o shm dfr:normStoreM // matirx to nomalize the data

	// header0 
	//make/T/N=100/o dfr:header0
	
	//MatrixList
	Make/O/T/N=5000 dfr:MNList
	
	// Use in DataShow panel for Loading Data
	String/G dfr:LoadMatHead="MAT"
	Variable/G dfr:GV_ChoseOfCase
	Variable/G dfr:GV_EnterCase
	Variable/G dfr:GV_LoadSN
	Variable/G dfr:GV_LoadEN
	Variable/G dfr:GV_ChoseOfLoadCase
	Variable/G dfr:DataOpen_SEStilt
	Variable/G dfr:DataOpen_SEStheta
	Variable/G dfr:DataOpen_SEShv
	String/G dfr:DataOpen_SESpol
	Variable/G dfr:DataOpen_angleRead_flag
	Variable/G dfr:DataOpen_A1StartE
	Variable/G dfr:DataOpen_A1StepE
	Variable/G dfr:DataOpen_SES_IgorMultiData

	// Variables for matrix normalize in DataShow panel
	Variable/G dfr:DataOpen_flag_NR
	Variable/G dfr:DataOpen_NR_sp = 0
	Variable/G dfr:DataOpen_NR_ep = 100
	Variable/G dfr:DataOpen_flag_comb
	Variable/G dfr:DataOpen_comb_x = 1
	Variable/G dfr:DataOpen_comb_y = 1
	Variable/G dfr:DataOpen_flag_Norm
	Variable/G dfr:DataOpen_Norm_sr = 0
	Variable/G dfr:DataOpen_Norm_er =100
	Variable/G dfr:DataOpen_condfactor =1.002

	
End




Function DO_DtShw_MListUPdata()

	DFREF dfr = root:DataLoadFolder

	String Mlist
	String MatName1
	Variable ii, jj
	SVAR folderpath = dfr:GS_folderpath1
	wave/t ml=dfr:MNlist
	variable cond1
	
	NewPath/O tempath folderpath
	Mlist = indexedfile (tempath,-1,"????")
	cond1=cmpstr( stringfromlist(0,Mlist),"")
	if (cond1==0)
		print "first cell is null!!"
	endif
	Mlist = SortList(Mlist, ";", 16)


	ml = ""
	ii=0
	jj=0
	Do
		MatName1=stringfromlist(ii,Mlist)
		if ((stringmatch(MatName1,"*.txt")==1)||(stringmatch(MatName1,"*.mot")==1))
		ml[jj]=MatName1
		jj+=1
		elseif (stringmatch(MatName1,"*.krx")==1)
		ml[jj]=MatName1
		jj+=1
		elseif(stringmatch(MatName1,"*.pxt")==1||stringmatch(MatName1,"*.pxp")==1)
		ml[jj]=MatName1
		jj+=1
		elseif(stringmatch(MatName1,"*.ibw")==1)
		ml[jj]=MatName1
		jj+=1
		
		endif
		ii+=1
	while(cmpstr(MatName1,"")!=0)
	
	String fc1, fc2
	fc1= ml[0]
	fc2= ml[1]
	if (grepstring(fc1,"00000")==0&&grepstring(fc1,"0001")==1&&grepstring(fc2,"0002")==1)
		InsertPoints 0,1, ml
		DeletePoints 1000,1, ml
	endif

	
end



Function DO_DtShw_DataUPdata()

	DFREF dfr = root:DataLoadFolder

	SVAR dataname= dfr:GS_dataname
	SVAR folderpath = dfr:GS_folderpath1
//	wave/T dataheader = dfr:header0
	wave m0 = dfr:storeM0
	wave sm = dfr:showM

	NVAR condfactor = dfr:DataOpen_condfactor
	//condfactor = 1.002
	NVAR ses_igormulti = dfr:DataOpen_SES_IgorMultiData
	
	PauseUpdate; Silent 1
	//string filename
	//filename = folderpath1+dataname
	NewPath/O/Q tempath folderpath
	
	getfilefolderinfo/P=tempath/Q  dataname
	if (V_isFile==0)   // if data of dataname exists, V_isFile==1
		sm =0
		return -1
	endif	
	
		if ((stringmatch(dataname,"*.txt")==1)||(stringmatch(dataname,"*.mot")==1)) //  A1 data loading  (txt/mot) 

			DO_DtShw_A1txt2D(m0,folderpath,dataname)
		
		endif
		
		if (stringmatch(dataname,"*.krx")==1) 	//  A1 data loading  (krx)   
		
			DO_DtShw_krxfile2D(m0,folderpath,dataname)
			
		endif
		
		if (stringmatch(dataname,"*S.krx")==1) 	//  A1 data loading Spin  (krx)   
		
			DO_DtShw_krxfileSpin(m0,folderpath,dataname)
			
		endif
		
		if (stringmatch(dataname,"*.pxt")==1)			/// SES data loading  
			
			DO_DtShw_SES2D(m0,folderpath,dataname,ses_igormulti)
			
		elseif (stringmatch(dataname,"*.pxp")==1)
			
			DO_DtShw_SES2D(m0,folderpath,dataname,ses_igormulti)
			
		elseif (stringmatch(dataname,"*.ibw")==1)
		
			DO_DtShw_SESBinary(m0,folderpath,dataname,ses_igormulti)
		
		endif
		
		

	duplicate/o m0 sm
	
		
	/////////////////  Normarization  //////////////////////////////
	
	
	NVAR flag_nr = dfr:DataOpen_flag_NR
	NVAR nr_sp = dfr:DataOpen_NR_sp
	NVAR nr_ep = dfr:DataOpen_NR_ep
	NVAR flag_comb = dfr:DataOpen_flag_comb
	NVAR combx = dfr:DataOpen_comb_x
	NVAR comby = dfr:DataOpen_comb_y
	wave redxymat = dfr:redxymat
	NVAR flag_norm = dfr:DataOpen_flag_Norm
	NVAR normsp= dfr:DataOpen_Norm_sr
	NVAR normep = dfr:DataOpen_Norm_er
	
	wave normm0 = dfr:normStoreM

	String Stornote
	Stornote = note(m0)
	duplicate/o m0 normm0
	redimension/D normm0

		if(flag_nr==1)
			  DO_DtShw_BGnoiseRemove(normm0, nr_sp,nr_ep, condfactor)
			  Note normm0, Stornote
		endif
		
		if(flag_norm==1)
			if (normsp <= normep )
			  DO_DtShw_NormMat(normm0, normsp ,normep)
			else
			 print "start point has to be smaller than end point"
			endif
			Note normm0, Stornote
		endif
		
		
		if(flag_comb==1)
			if (combx>=1 && comby>=1)
			  DO_DtShw_CombMat(normm0, combx, comby)
			endif 
				Note normm0, Stornote
		endif
		
		duplicate/o normm0 sm  
		
end





Function DO_DtShw_AngleRecord(index1, prompt_flag)
Variable index1
Variable prompt_flag
	
	DFREF dfr = root:DataLoadFolder

	NVAR SEStilt = dfr:DataOpen_SEStilt
	NVAR SEStheta = dfr:DataOpen_SEStheta
	NVAR SEShv = dfr:DataOpen_SEShv
	NVAR angleRead_flag = dfr:DataOpen_angleRead_flag
	wave angle
	
	variable tilt, theta, hv
	
	tilt = round(SEStilt*100)/100
	theta = round(SEStheta*100)/100
	hv = round(SEShv)
	
	
	Variable CaseOfInfo = angleRead_flag
	string message
	
	if (prompt_flag==1)
		message= "Do you want to record angle/hv ?" 
		Prompt CaseOfInfo, message, popup, "Yes, record angle tilt ; Yes, record hv; No"
		Doprompt "Record to angle wave", CaseOfInfo
		angleRead_flag = CaseOfInfo
	endif	
	
		
	switch (CaseOfInfo)
			case 1:
				angle[index1] = tilt
				break
			case 2:
				angle[index1] = hv
				break
			case 3:
				break
	endswitch
	
			
End





Function DO_DtShw_RestLengthCheck(sn,en, lastcell)
Variable sn,en,lastcell
		Variable checklength
		Variable restlength 
		Variable addlength
		Variable base_cond
		wave/T x_base, y_base
		
		String Wname
		String WList =  "X_base;Last_Wave;Offset_Wave;Bias_Wave;Angle;Info_Wave;Y_base;X_start_Wave;Start_Wave;memo;"
		variable ii=0
		ii=0
		Do
			Wname = Stringfromlist(ii,WList)
			checklength = dimsize($Wname,0)
			restlength = checklength - lastcell -1	
			if (restlength <= (en-sn+1))
				addlength = (en-sn+1)-restlength
				InsertPoints (checklength),(addlength) ,$Wname
				 base_cond = cmpstr(Wname, "x_base")
				 if (base_cond==0)
				 	x_base[checklength,]="xwave"
				 endif
				 base_cond = cmpstr(Wname, "y_base")
				  if (base_cond==0)
				 	y_base[checklength,]="wave"
				 endif						
			endif		
			ii+=1
		while(ii<10)	
End


Function DO_DtShw_LastOccupiedCell_TXT(w1)
wave/T w1

	Variable lastcell, wavelength
	String s1
	Variable cond1,cond2
	Variable ii=0, jj=0
	wavelength = dimsize(w1, 0)
	jj = wavelength-1
		Do
			s1 = w1[jj]
			cond1=cmpstr(s1,"")	
			if (cond1==1)
			break
			endif
			jj-=1
		while(jj>-1)
	lastcell = jj
return lastcell
End

Function DO_DtShw_LastOccupiedCell(w1)
wave w1

	Variable lastcell, wavelength
	Variable n1
	Variable cond1,cond2
	Variable ii=0, jj=0
	wavelength = dimsize(w1, 0)
	jj = wavelength-1
		Do
			n1 = w1[jj]
			if (n1>0)
			break
			endif
			jj-=1
		while(jj>-1)
	lastcell = jj
return lastcell
End


Function/s DO_DtShw_CandNameList(Numlist)
String  Numlist

	Variable ii=0,sl
	Variable cond1
	String sn,sn0,Sname
	String shead

	DFREF dfr = root:DataLoadFolder

	SVAR head = dfr:LoadMatHead
	SVAR dataname = dfr:GS_dataname
	String NameList=""

	
	Do  ///////////////////////////  最初の3候補 (LoadMatHead + 数字列)作成 ////////////////
		sn = stringfromlist (ii, Numlist)
		cond1 = cmpstr(sn,"")
		
		if (cond1==1)
			sl = strlen(sn)
			if (sl>3)
				sn0=sn[sl-4,sl-1]
			endif
		
			if (sl==3)
				sn0="0"+sn
			elseif (sl==2)
				sn0="00"+sn
			elseif (sl==1)
				sn0="000"+sn
			endif
			
			Sname = head + sn0
			
			if (grepstring(dataname, ".mot"))
				Sname+="mot"
			endif
		
		else
			Sname ="NoCandidate"
		endif
		
		
		NameList +=  Sname + ";"
		
		ii=ii+1
		
	while (ii<3)
	
	ii=0
	Do  ///////////////////////////  次の3候補 (文字列 + 数字列)作成 ////////////////
		sn = stringfromlist (ii, Numlist)
		cond1 = cmpstr(sn,"")
		
		if (cond1==1)
			sl = strlen(sn)
			if (sl>3)
				sn0=sn[sl-4,sl-1]
			endif
		
			if (sl==3)
				sn0="0"+sn
			elseif (sl==2)
				sn0="00"+sn
			elseif (sl==1)
				sn0="000"+sn
			endif
			
			shead = dataname[0]
			Sname = shead + sn0
			
			if (grepstring(dataname, ".mot"))
				Sname+="mot"
			endif
		
		else
			Sname ="NoCandidate"
		endif
		
		
		NameList +=  Sname + ";"
		
		ii=ii+1
		
	while (ii<3)
	
		ii=0
	Do  ///////////////////////////  次の3候補 (文字列2 + 数字列)作成 ////////////////
		sn = stringfromlist (ii, Numlist)
		cond1 = cmpstr(sn,"")
		
		if (cond1==1)
			sl = strlen(sn)
			if (sl>3)
				sn0=sn[sl-4,sl-1]
			endif
		
			if (sl==3)
				sn0="0"+sn
			elseif (sl==2)
				sn0="00"+sn
			elseif (sl==1)
				sn0="000"+sn
			endif
			
			shead =dataname[0,1]
			Sname = shead + sn0
			
			if (grepstring(dataname, ".mot"))
				Sname+="mot"
			endif
		
		else
			Sname ="NoCandidate"
		endif
		
		
		NameList +=  Sname + ";"
		
		ii=ii+1
		
	while (ii<3)

return (NameList)
End


Function/s  DO_DtShw_ExtractDataNum(Dname)
String Dname

	String ResaltantList
	///////////////////// 拡張子を除去して、Dnameにデータ名を格納///////////
	Variable CommaP
	String DnameMB	
	CommaP = strsearch (Dname,".",0)
	
	if (CommaP==-1)  
		DnameMB = Dname
	else		
		Do
			Dname=removeending(dname)	
			CommaP = strsearch (Dname,".",0)
		while(Commap!=-1)
		DnameMB=Dname
	endif
	
	////////////////////////////////////////////////////////////////////////////
	String ListDname, ld2=""
	
	ListDname =  DO_DtShw_PartionString(DnameMB) ////////////////// DnameMBデータ名を;でしきり
	
	Variable ii=0, condf, condx, fl
	String sv1="",sv2="",sv3=""
	String ts1,rs1
	String fs1,fs2
	
	Do
		ts1 = stringfromlist (ii, ListDname)
		if (grepstring(ts1,"[0-9]+"))  
			fl = strlen(ts1)
		 	if( fl>=5)
		 		fs1=ts1[0,fl-5]
		 		fs2=ts1[fl-4,fl-1]
		 		
		 		ld2 += fs1 + ";" + fs2 + ";"
		 		
		 	else
		 	
		 		ld2 += ts1 + ";" 
		 		
			endif
		endif
	
		ii+=1
		condx =  cmpstr( stringfromlist (ii, ListDname),"")
	while (condx==1)	
	
	ListDname = ld2

	
	ii=0
	Variable cond1,cond2, cond3
	
	Do
		ts1 = stringfromlist (ii, ListDname)
		
		if (grepstring(ts1,"[0-9]+"))  ////////  ts1が数字列か？
			
			cond1 = cmpstr(sv1,"")
			cond2 = cmpstr(sv2,"")
			cond3 = cmpstr(sv3,"")
			
			if ((cond1==0)&&(cond2==0)&&(cond3==0))  
				sv1 = ts1
			elseif ((cond1==1)&&(cond2==0)&&(cond3==0))
				sv2 = ts1
				///////////// 条件判定 sv1,sv2
				condf = DO_DtShw_CompareNumber(sv1,sv2)
				if  (condf==1) ////// sv2がsv1より優勢
					rs1=sv1
					sv1=sv2
					sv2=rs1
				endif
				
			elseif  ((cond1==1)&&(cond2==1)&&(cond3==0))
				sv3 = ts1
				///////////// 条件判定 sv3,sv2
				condf = DO_DtShw_CompareNumber(sv2,sv3)
				if  (condf==1) ////// sv3がsv2より優勢
					rs1=sv2
					sv2=sv3
					sv3=rs1
				endif
				///////////// 条件判定 sv1,sv2
				condf = DO_DtShw_CompareNumber(sv1,sv2)
				if  (condf==1) ////// sv2がsv1より優勢
					rs1=sv1
					sv1=sv2
					sv2=rs1
				endif
				
			else
				///////////// 条件判定 ts1,sv3
				condf = DO_DtShw_CompareNumber(sv3,ts1)
				if  (condf==1) ////// ts1がsv3より優勢
					sv3=ts1
				endif
				
				///////////// 条件判定 sv3,sv2
				condf = DO_DtShw_CompareNumber(sv2,sv3)
				if  (condf==1) ////// sv3がsv2より優勢
					rs1=sv2
					sv2=sv3
					sv3=rs1
				endif
				
				///////////// 条件判定 sv1,sv2
				condf = DO_DtShw_CompareNumber(sv1,sv2)
				if  (condf==1) ////// sv2がsv1より優勢
					rs1=sv1
					sv1=sv2
					sv2=rs1
				endif
			endif			
			
		endif
		
		
		
		ii= ii +1
		condx =  cmpstr( stringfromlist (ii, ListDname),"")
	while (condx==1)	
	
	ResaltantList= sv1 + ";" + sv2 + ";" + sv3
		
	
	return (ResaltantList)
End
	
	
Function/s DO_DtShw_PartionString(name)
String name
	/// Insert ";" betewwm character and number
	Variable sl
	String ListDname=""
	String fc1,fc2
	variable cond1,cond2
	Variable iii= 1
	
	sl = strlen(name)
		Do
			fc1 = name[iii-1]
			fc2 = name[iii]
			ListDname = ListDname +  fc1 
			cond1 =  (grepstring(fc1,"[0-9]") && grepstring(fc2,"[^0-9]"))
			cond2 =  (grepstring(fc1,"[^0-9]") && grepstring(fc2,"[0-9]"))
			if (cond1 || cond2)
				ListDname = ListDname  + ";"
			endif
			iii= iii+1
		while(iii<sl)
		ListDname = ListDname +  fc2
	
	
return (ListDname)
	
End


Function DO_DtShw_CompareNumber(num1,num2)
String num1,num2
	
	Variable FinalCond
	Variable point1,point2
	String num10,num20
	variable ff1,ff2
	
	variable sl1,sl2
	sl1 = strlen(num1)
	sl2 = strlen(num2)
		
	if (sl1>3)  ///////////  4桁以上ならば 100点加算
	 	point1+=100
	endif
	
	if (sl2>3) ///////////  4桁以上ならば 100点加算
	 	point2+=100
	endif
	
	 ///////////  num1,num2とともに4桁以上ならば　下4桁の数が少ない方が勝ち
//	if ((sl1>3)&&(sl2>3))
//		num10=num1[sl1-3,sl1]
//		num20=num2[sl2-3,sl2]
//		ff1 = str2num(num10)
//		ff2 = str2num(num20)
//		if (ff1<ff2)
//			point1+=100
//		elseif (ff1>ff2)
//			point2+=100
//		endif		
//	endif
	
	 ///////////  num1,num2とともに4桁以下ならば数の多い方が勝ち
//	if ((sl1<4)&&(sl2<4))
//		ff1 = str2num(num1)
//		ff2 = str2num(num2)
//		if (ff1>ff2)
//			point1+=10
//		elseif (ff1<ff2)
//			point2+=10
//		endif		
	
//	endif
	
	
	if (point1>point2)
	FinalCond = 0
	elseif (point1<point2)
	FinalCond = 1
	elseif (point1==point2)
	FinalCond = 0
	endif
	
return (FinalCond)
End






Function DO_DtShw_BGnoiseRemove(matname,sp,ep, condfactor)
wave matname //, pointtable
Variable sp,ep
variable condfactor

	duplicate/o matname, NPtestmat
	variable ysize
	ysize = dimsize(matname,1)
	
	Make/N=(ysize)/D/O BGmdc=0
	
	Variable ii=sp
	Do
		BGmdc+=matname[ii][p]
		ii+=1
	while (ii< ep+1)
	
	ii=2
	Variable p1,p2,p3,p4,p5, pav
	Variable NGpoint, NGvalue
	Do
		p1 =	BGmdc[ii-2] 
		p2 =	BGmdc[ii-1]
		p3 =	BGmdc[ii] 
		p4 =	BGmdc[ii+1] 
		p5 =	BGmdc[ii+2] 
		pav = (p1+p2+p4+p5)/4
		
		if ((p3)>=(pav*condfactor))
//			print NGpoint, p3
			NGpoint=ii
			NGvalue=(p3-pav)/(ep-sp+1)
			NPtestmat[][NGpoint]-=NGvalue
		endif
		
		ii+=1
	while(ii<ysize-1)
	
	duplicate/o NPtestmat, matname 
	killwaves/Z NPtestmat, BGmdc

End


Function DO_DtShw_CombMat(nrmm, cx, cy)
wave nrmm
Variable cx, cy

	variable xsize, ysize
	xsize = dimsize(nrmm,0)
	ysize = dimsize(nrmm,1)
//	print "xsize,ysize", xsize,ysize
	variable cxsize, cysize
	cxsize = floor(xsize/cx) + (mod(xsize,cx)!=0) //second term adding one more pixel for redidual 
	cysize = floor(ysize/cy) + (mod(ysize,cy)!=0)
//	print "cxsize,cysize", cxsize,cysize

	Make/O/N=(cxsize, ysize) redxmat
	redxmat =0
	variable ii=0, jj=0
	
	Do   
		jj=0
		Do
			if ((ii*cx+jj)< (xsize+1))
			redxmat[ii][] +=  nrmm[ii*cx+jj][q]
			else
			redxmat[ii][] +=  nrmm[xsize][q]
			endif		
		jj+=1
		while (jj<(cx))
	ii+=1
	while(ii<(cxsize))
			
	Make/O/N=(cxsize, cysize)  redxymat
	
	redxymat =0
	ii=0
	Do
		jj=0
		Do
			if ((ii*cy+jj)< (ysize+1))
			redxymat[][ii] +=  redxmat[p][ii*cy+jj]
			else
			redxymat[][ii] +=  redxmat[q][ysize]
			endif		
		jj+=1
		while (jj<(cy))
	ii+=1
	while(ii<(cysize))

	variable xoffset, yoffset
	xoffset = dimoffset(nrmm,0)
	yoffset = dimoffset(nrmm,1)
	variable xdelta, ydelta
	xdelta = dimdelta(nrmm,0)
	ydelta = dimdelta(nrmm,1)
	string xscale,yscale
	xscale = waveunits(nrmm,0)
	yscale = waveunits(nrmm,1)

	variable cxoffset = xoffset + (cx-1)/2*xdelta
	variable cyoffset = yoffset + (cy-1)/2*ydelta
	variable cxdelta = cx* xdelta
	variable cydelta = cy* ydelta

	SetScale/P x cxoffset, cxdelta,xscale, redxymat
	SetScale/P y cyoffset, cydelta,yscale, redxymat
	
	Redimension/N=(cxsize, cysize)  nrmm
	duplicate/o redxymat, nrmm
	
	killwaves/Z redxmat,redxymat

End




Function DO_DtShw_NormMat(matname, sr , er)
wave matname
Variable sr, er

	variable ydim=Dimsize(matname,1)
	variable xdim=Dimsize(matname,0)
	duplicate/o matname showmat_image
	Make/N=(ydim)/D/O normfactor
	
	if (xdim<er)
		er=xdim
	endif

	normfactor=0
	variable ii
	ii= sr
	Do
		normfactor[]+=matname[ii][p]
	ii+=1
	while(ii<er+1)
	
	variable sump
	//sump = sum(normfactor)
	//normfactor+=(sump/100)
	showmat_image[][]/=normfactor[q]

	wavestats/Q showmat_image
	showmat_image*=50000/v_max
	
 	matname=showmat_image
 	killwaves/Z showmat_image,normfactor
 	
end


Function DO_DtShw_MNormMat(matname, sr , er)
wave matname
Variable sr, er

	variable ydim=Dimsize(matname,1)
	variable xdim=Dimsize(matname,0)
	duplicate /o matname showmat_image
	Make/N=(xdim)/D/O normfactor
	
	if (ydim<er)
		er=ydim
	endif

	normfactor=0
	variable ii
	ii= sr
	Do
		normfactor[]+=matname[p][ii]
		ii+=1
	while(ii<er+1)
	
	variable sump
	//sump = sum(normfactor)
	//normfactor+=(sump/100)
	showmat_image[][]/=normfactor[p]

	wavestats/Q showmat_image
	showmat_image*=50000/v_max
	
 	matname=showmat_image
end







Window SESinfo() 
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1213,117,1328,184)
	ModifyPanel cbRGB=(53400,65535,41243)
	SetDrawLayer UserBack
	DrawText 6,16,"SESinfo(PF)"
	ValDisplay valdisp0,pos={12.00,19.00},size={83.00,13.00},title="Tilt"
	ValDisplay valdisp0,limits={0,0,0},barmisc={0,1000}
	ValDisplay valdisp0,value= #":DataLoadFolder:DataOpen_SEStilt"
	ValDisplay valdisp1,pos={13.00,34.00},size={83.00,13.00},title="Theta"
	ValDisplay valdisp1,limits={0,0,0},barmisc={0,1000}
	ValDisplay valdisp1,value= #":DataLoadFolder:DataOpen_SEStheta"
	ValDisplay valdisp2,pos={13.00,50.00},size={83.00,13.00},title="hv"
	ValDisplay valdisp2,limits={0,0,0},barmisc={0,1000}
	ValDisplay valdisp2,value= #":DataLoadFolder:DataOpen_SEShv"
	Button button4,pos={74.00,2.00},size={35.00,16.00},proc=DO_DtShw_button_SESinfoClose,title="done"
	Button button4,fSize=10,fColor=(65535,16385,16385)
EndMacro



Function DO_DtShw_GetSESAnaConInfo(w)  //read data acquision information for IshizakaLab automapping vi
wave w

	DFREF dfr = root:DataLoadFolder

	String testStr
	variable tiltangle, theta, hv
	string polmode = ""

	NVAR  SEStilt = DataOpen_SEStilt 
	NVAR  SEStheta  = DataOpen_SEStheta 
	NVAR  SEShv = DataOpen_SEShv
	SVAR  SESpol = DataOpen_SESpol

	string notelist = note(w)	
	if (cmpstr(notelist,"")==0)
		return -1
	endif

	
	variable ii=0, listnum = ItemsInList (notelist, "\r")
	
	
	Do
		testStr = StringFromList (ii, notelist, "\r")
			 	
			if (GrepString(testStr,"(?i)flip"))
				sscanf testStr, " flip= %f", tiltangle
				//print "tilt =", tiltangle
			endif
			if (GrepString(testStr,"(?i)theta"))
				sscanf testStr, " theta= %f", theta
			//	print "theta =", theta
			endif
			if (GrepString(testStr,"(?i)excitation"))
				sscanf testStr, " Excitation Energy= %f", hv
			//	print "hv =", hv
			endif
			if (GrepString(testStr,"(?i)polarization"))
				sscanf testStr, " Polarization=%s", polmode
			//	print "POL =", polmode
			endif
			
		ii = ii +1
	while(ii < listnum)
	
	SEStilt = tiltangle
	SEStheta = theta
	SEShv = hv
	SESpol = polmode
			
end



Function DO_DtShw_krxfile2D(m0,folderpath,dataname) 
wave m0
String dataname,folderpath

	DFREF dfr = root:DataLoadFolder
	
	Variable refnum
	Variable v0, v1
	Variable n_images, image_pos, image_sizeX, image_sizeY, header_pos
	Variable ii
	Variable x0, x1, y0, y1, e0, e1
	String w_basename = "image_"
	String w_name
	Variable Is64bit

	
	String header = PadString("", 1200, 32)	// 1200 bytes should do it
	String header_short
	
	Newpath/O/Q pathtodata folderpath	
	Open/R/p=pathtodata refnum as dataname
	
	// 32 bit - 64 bit autodetect: 
	// Data is written with little-endian -> The second 32 bit word is 0 for a 64 bit file unless the file contains > 2 10^9 images, which we will exclude.
	FSetPos refNum, 4
	FBinRead/B=3/F=3 refNum, v0
	if (v0 == 0)
		Is64bit = 1
	else
		Is64bit = 0
	endif

	// krax files contain 32 bit / 4 byte integers
	//	FBinRead/B=3/F=3 refNum, v1		//F=3 reads four bytes
	

	
	// size and position of first image:
	// pointers can be 64 bit or 32 bit integers
	// data is 32 bit / 4 byte integers
	if (Is64bit)
		FSetPos refNum, 0
		FBinRead/B=3/F=6 refNum, v1					// F=6 reads 8 byte integer
		n_images = v1/3	
		
		FSetPos refNum, 8									// second number in 64-bit file starts at byte 8
		FBinRead/B=3/F=6 refNum, image_pos			// file-position of first image
		FSetPos refNum, 16
		FBinRead/B=3/F=6 refNum, image_sizeY		// Parallel detection angle
		FSetPos refNum, 24
		FBinRead/B=3/F=6 refNum, image_sizeX		// Energy coordinate
	else
		FSetPos refNum, 0
		FBinRead/B=3/F=3 refNum, v1					//F=3 reads four bytes
		n_images = v1/3	
		
		FSetPos refNum, 4									// second number in file starts at byte 4
		FBinRead/B=3/F=3 refNum, image_pos			// file-position of first image
		FSetPos refNum, 8
		FBinRead/B=3/F=3 refNum, image_sizeY		// seems to be parallel detection angle
		FSetPos refNum, 12
		FBinRead/B=3/F=3 refNum, image_sizeX		// seems to be energy coordinate
	endif

	// autodetect header format and get wave scaling from first header :
	header_pos = (image_pos + image_sizeX * image_sizeY + 1) * 4			// position of first header	
	FSetPos refNum, header_pos		
	FBinRead/B=3 refNum, header
	v0 = strsearch(header, "DATA:", 0)
	header_short = header[0,v0-1]
	
	if (stringmatch(header_short,"Lines*"))			
		// new headers starting with "Lines\t..."
		e0 = NumberByKey("Start K.E.", header_short,"\t","\r\n")
		e1 = NumberByKey("End K.E.", header_short,"\t","\r\n")
		x0 = NumberByKey("ScaleMin", header_short,"\t","\r\n")		// parallel detection
		x1 = NumberByKey("ScaleMax", header_short,"\t","\r\n")
		y0 = NumberByKey("MapStartX", header_short,"\t","\r\n")		// deflector
		y1 = NumberByKey("MapEndX", header_short,"\t","\r\n")

	else																
		// old header
		e0 = NumberByKey("Start K.E.", header_short,"\t","\r\n")
		e1 = NumberByKey("End K.E.", header_short,"\t","\r\n")
		x0 = NumberByKey("XScaleMin", header_short,"\t","\r\n")		// parallel detection
		x1 = NumberByKey("XScaleMax", header_short,"\t","\r\n")
		y0 = NumberByKey("YScaleMin", header_short,"\t","\r\n")		// deflector
		y1 = NumberByKey("YScaleMax", header_short,"\t","\r\n")
	endif
	
	
	 // if krx data is not a normal 2D map, this dataload is pended
	if (n_images!=1)
		print "data is not 2D mat, maybe have higher dimension"
		m0 = 0
		return -1
	endif
	

	Make/O/I/N=(image_sizeX, image_sizeY) databuffer	// note 32 bit integer format (runs faster). Change /I to /S for single precision floating point
	
	ii = 0
	
		if (Is64bit)
			FSetPos refNum, (ii*3 + 1) * 8			// pointers to image positions are at bytes 8, 32, 56,... 
			FBinRead/B=3/F=6 refNum, image_pos		// this is the image position in 32 bit integers. Position in bytes is 4 times that
		else
			FSetPos refNum, (ii*3 + 1) * 4			// pointers to image positions are at bytes 4, 16, 28,... 
			FBinRead/B=3/F=3 refNum, image_pos		// this is the image position in 32 bit integers. Position in bytes is 4 times that
		endif
		
//	FSetPos refNum, (ii*3 + 1) * 4			// pointers to image positions are at bytes 4, 16, 28,... 
//	FBinRead/B=3/F=3 refNum, image_pos	// this is the image position in 32 bit integers. Position in bytes is 4 times that
	
	//	read image
	FSetPos refNum, image_pos*4
	FBinRead/B=3/F=3 refNum, databuffer
		
	// read header into string.
		FSetPos refNum, (image_pos + image_sizeX * image_sizeY + 1) * 4	// position of the header
		FBinRead/B=3 refNum, header
		v0 = strsearch(header, "DATA:", 0)
		header_short = header[0,v0-1]
	
//	e0 = NumberByKey("Start K.E.", header,"\t","\r\n")
//	e1 = NumberByKey("End K.E.", header,"\t","\r\n")
//	y0 = NumberByKey("ScaleMin", header,"\t","\r\n")
//	y1 = NumberByKey("ScaleMax", header,"\t","\r\n")
	
	
	Duplicate/O databuffer m0
	//Redimension/S $w_name								// Converts to SP floating point. Is rather slow.
	SetScale/I x e0, e1, "eV" m0
	SetScale/I y x0, x1, "deg" m0
	Note/K m0, header_short
		
	Close refnum
//	KillWaves/Z databuffer
			
end



Function DO_DtShw_krxfileSpin(m0,folderpath,dataname)
wave m0
String dataname,folderpath

	DFREF dfr = root:DataLoadFolder
	//SVAR dataname= dfr:GS_dataname
	//SVAR folderpath = dfr:GS_folderpath1
	//wave m0 = dfr:storeM0
		
	Variable refnum
	Variable v0, v1
	Variable n_images, image_pos, image_sizeX, image_sizeY, header_pos
	variable DimsnsionSize,LL, MSA0,MSA1,MSA2,MSA3,MSA4
	Variable ii
	Variable x0, x1, y0, y1, e0, e1
	String w_basename = "image_"
	String w_name
	Variable Is64bit, IsSpin

	
	String header = PadString("", 800, 32)	// 1200 bytes should do it
	String header_short
	
	Newpath/O/Q pathtodata folderpath	
	Open/R/p=pathtodata refnum as dataname
	
	// 32 bit - 64 bit autodetect: 
	// Data is written with little-endian -> The second 32 bit word is 0 for a 64 bit file unless the file contains > 2 10^9 images, which we will exclude.
	FSetPos refNum, 4
	FBinRead/B=3/F=3 refNum, v0
	if (v0 == 0)
		Is64bit = 1
	else
		Is64bit = 0
	endif
	
	// size and position of first image:
	// pointers can be 64 bit or 32 bit integers
	// data is 32 bit / 4 byte integers
	if (Is64bit)
		FSetPos refNum, 0
		FBinRead/B=3/F=6 refNum, v1					// F=6 reads 8 byte integer
		n_images = v1/3	
		
		FSetPos refNum, 8									// second number in 64-bit file starts at byte 8
		FBinRead/B=3/F=6 refNum, image_pos			// file-position of first image
		FSetPos refNum, 16
		FBinRead/B=3/F=6 refNum, image_sizeY		// Parallel detection angle
		FSetPos refNum, 24
		FBinRead/B=3/F=6 refNum, image_sizeX		// Energy coordinate
	else
		FSetPos refNum, 0
		FBinRead/B=3/F=3 refNum, v1					//F=3 reads four bytes
		n_images = v1/3	
		
		FSetPos refNum, 4									// second number in file starts at byte 4
		FBinRead/B=3/F=3 refNum, image_pos			// file-position of first image
		FSetPos refNum, 8
		FBinRead/B=3/F=3 refNum, image_sizeY		// seems to be parallel detection angle
		FSetPos refNum, 12
		FBinRead/B=3/F=3 refNum, image_sizeX		// seems to be energy coordinate
	endif


//	print "PAS", n_images, "image_pos",image_pos, "image_sizeY",image_sizeY,"image_sizeX",image_sizeX 
	
	//Dimension size , L, Map Size Array (MSA) 
	// locte after PAS 
	if (Is64bit)
		FSetPos refNum, (8 + 24*n_images)
		FBinRead/B=3/F=6 refNum, DimsnsionSize
		//FSetPos refNum, (8 + 24*n_images +8)
		//FBinRead/B=3/F=6 refNum, LL
		FSetPos refNum, (8 + 24*n_images +16)
		FBinRead/B=3/F=6 refNum, MSA0
			FSetPos refNum, (8 + 24*n_images +24)
		FBinRead/B=3/F=6 refNum, MSA1
			FSetPos refNum, (8 + 24*n_images +32)
		FBinRead/B=3/F=6 refNum, MSA2
			FSetPos refNum, (8 + 24*n_images +40)
		FBinRead/B=3/F=6 refNum, MSA3
		
		if (DimsnsionSize==5)						//dimension size = 5: spin, dimension size = 4: arpes
			IsSpin = 1
			FSetPos refNum, (8 + 24*n_images +48)
			FBinRead/B=3/F=6 refNum, MSA4
		elseif(DimsnsionSize==4)
			IsSpin = 0
			MSA4 = NAN
		endif
		
	else
		FSetPos refNum, (4 + 12*n_images)
		FBinRead/B=3/F=3 refNum, DimsnsionSize
		FSetPos refNum, (4 + 12*n_images +8)
		FBinRead/B=3/F=3 refNum, MSA0
			FSetPos refNum, (4 + 12*n_images +12)
		FBinRead/B=3/F=3 refNum, MSA1
			FSetPos refNum, (4 + 12*n_images +16)
		FBinRead/B=3/F=3 refNum, MSA2
			FSetPos refNum, (4 + 12*n_images +20)
		FBinRead/B=3/F=3 refNum, MSA3
		
		if (DimsnsionSize==5)						//dimension size = 5: spin, dimension size = 4: arpes
			IsSpin = 1
			FSetPos refNum, (4 + 12*n_images +24)
			FBinRead/B=3/F=3 refNum, MSA4
		elseif(DimsnsionSize==4)
			IsSpin = 0
			MSA4 = NAN
		endif
	endif


	//set up spin matrix
	Make/O/I/N=(image_sizeX) databuffer	// note 32 bit integer format (runs faster). Change /I to /S for single precision floating point
	Make/O/I/N=(image_sizeX,4) spinm
		
	for (ii=0;ii<4;ii +=1)

		if (Is64bit)
			FSetPos refNum, (ii*3 + 1) * 8			// pointers to image positions are at bytes 8, 32, 56,... 
			FBinRead/B=3/F=6 refNum, image_pos		// this is the image position in 32 bit integers. Position in bytes is 4 times that
		else
			FSetPos refNum, (ii*3 + 1) * 4			// pointers to image positions are at bytes 4, 16, 28,... 
			FBinRead/B=3/F=3 refNum, image_pos		// this is the image position in 32 bit integers. Position in bytes is 4 times that
		endif
			
	
		//	read image
		FSetPos refNum, image_pos*4
		FBinRead/B=3/F=3 refNum, databuffer
		
		// read header into string.
		FSetPos refNum, (image_pos + image_sizeX * image_sizeY + 1) * 4	// position of the header
		FBinRead/B=3 refNum, header
		v0 = strsearch(header, "DATA:", 0)
		header_short = header[0,v0-1]
	
		e0 = NumberByKey("Start K.E.", header,"\t","\r\n")
		e1 = NumberByKey("End K.E.", header,"\t","\r\n")
		y0 = NumberByKey("ScaleMin", header,"\t","\r\n")
		y1 = NumberByKey("ScaleMax", header,"\t","\r\n")
	
	
	
		spinm[][ii] = databuffer[p]
		
	endfor
	
	duplicate/o spinm m0
	//Redimension/S $w_name								// Converts to SP floating point. Is rather slow.
	SetScale/I x e0, e1, "eV" m0
//	SetScale/I y y0, y1, "deg" m0
	Note/K m0, header_short
		
	Close refnum
//	KillWaves/Z databuffer


			
end

Function DO_DtShw_A1txt2D(mattoload,folderpath,dataname) //DO_DtShw_A1txt2D(m0,folderpath,dataname)
wave mattoload
string dataname,folderpath

//	DFREF dfr = root:DataLoadFolder
//	SVAR dataname = dfr:GS_dataname
//	SVAR folderpath = dfr:GS_folderpath1
	//wave m0 = dfr:storeM0

	Variable refnum 
	Variable v0, v1
	Variable ii
	Variable x0, x1, y0, y1, e0, e1, y2flag
	variable olddataflag = 0
	
	String header = PadString("", 2400, 32)	// 1200 bytes should do it
	String header_short
	string loadwavename
	
//	variable/G e0G,e1G,y0G,y1G
	string/G header_info, headershort_info
	
	// 2D map is stord to storeM0
	Newpath/O/Q pathtodata folderpath
	Open/R/p=pathtodata refnum as dataname
	LoadWave/G/M/N=loadM/O/P=pathtodata/Q dataname 
	loadwavename = StringFromList(0,S_wavenames)
	duplicate/o $loadwavename mattoload
	FSetPos refNum, 1
	FreadLine/T=";"/N=2400 refNum,header
	v0 = strsearch(header, "DATA:", 0)
	header_short = header[0,v0-1]

header_info=header
 headershort_info=header_short
	
	
	e0 = NumberByKey("Start K.E.", header,"\t","\r\n")
	e1 = NumberByKey("End K.E.", header,"\t","\r\n")
	y0 = NumberByKey("XScaleMin", header,"\t","\r\n")
	y1 = NumberByKey("XScaleMax", header,"\t","\r\n")
	y2flag =  NumberByKey("ScaleMax", header,"\t","\r\n")

 // (1.3.0.10) old txt does not have ScaleMin(Max) nor XScaleMin(Max)
 // No sclae information of y axis in matrix is used for judgeing new or old
 // For energy, Either line of "Start K.E." and that of "Start K.E.        :"　is used
 // In even older style, K.E. Low is used 
	if (numtype(y0)==2 && numtype(y2flag)==2)
		olddataflag = 1
		string line1,s1
		line1 =greplist(header_short, "Start K.E.",0,"\r\n") // case for "Start K.E.        :"
		sscanf line1, "Start K.E. %s%f", s1,e0
		line1 =greplist(header_short, "End K.E.",0,"\r\n")
		sscanf line1, "End K.E. %s%f", s1,e1
		
		if (e0==0&&e1==0) // case for "Start K.E. "
			e0 = NumberByKey("Start K.E.", header,"\t","\r\n")
			e1 = NumberByKey("End K.E.", header,"\t","\r\n")
		endif
		
		if (numtype(e0)==2) // case for "K.E. Low"
			line1 =greplist(header_short, "K.E. Low",0,"\r\n")
			sscanf line1, "K.E. Low  %s%f", s1,e0
			line1 =greplist(header_short, "K.E. High",0,"\r\n")
			sscanf line1, "K.E. High  %s%f", s1,e1
		endif
		
	endif
	
	
	// (1.3.0.4) in case for Xscalse and Yscale are used in deflector system 
	//if (numtype(y0)==2 && olddataflag==0)		
	//	y0 = NumberByKey("XScaleMin", header,"\t","\r\n") 
	//	y1 = NumberByKey("XScaleMax", header,"\t","\r\n") 
	//endif	
	
	// (1.3.0.10) in case ScaleMax is used. Legacy before deflector system
	 if (numtype(y0)==2 && numtype(y2flag)==0)	
			y0 = NumberByKey("ScaleMin", header,"\t","\r\n") 
			y1 = y2flag
	endif														
	
	// (1.3.0.4) removing first column if it is energy scale
	// (1.3.0.4) Such column maybe appera in old-type A1 data
	// (1.3.0.10) y scale is drived from matrix size
	 if (olddataflag==1)		
	 		DeletePoints/M=1 0,1, mattoload
	 		y1 = Dimsize(mattoload,1)-1
			y0 = 0
	 endif
		

	//Redimension/S $w_name								// Converts to SP floating point. Is rather slow.
	
	//(1.3.0.10) Scale matrix for both type of txt data 
	if (olddataflag==0)	
		SetScale/I x e0, e1, "eV" mattoload
		SetScale/I y y0, y1, "deg" mattoload
	elseif (olddataflag==1)	
		SetScale/I x e0, e1, "eV" mattoload
		SetScale/I y y0, y1, "ch" mattoload
		if (Dimsize(mattoload,1)==1) // for 1D data 
			SetScale/I y 0, 1, "ch" mattoload
			print "1d"
		endif
	endif
	Note/K mattoload, header_short
	
	killwaves/Z $loadwavename	
	Close refnum
	
end



Function DO_DtShw_SES2D(m0,folderpath,dataname,igornum)
wave m0
String folderpath,dataname
Variable igornum

//	DFREF dfr = root:DataLoadFolder
//	SVAR dataname = dfr:GS_dataname
//	NVAR igormulti = dfr:DataOpen_SES_IgorMultiData
//	wave m0 = dfr:storeM0
	
	variable loaddatanum
	variable numinfolder
	string loadWaveName
	
	Newpath/O/Q pathtodata folderpath
	
	LOADDATA /p=pathtodata/q /T=load /L=1/O dataname
	setdatafolder root:load
			
	loaddatanum = igornum  //specify the data from igorfile in which mulitiple data porentially stored
	numinfolder =  CountObjects("root:load", 1)
		if (loaddatanum<numinfolder)
				loadWaveName = wavename ("",loaddatanum,4)
		else
				loadWaveName = wavename ("",0,4)
		endif
			
	setdatafolder root:
	duplicate/o root:load:$loadWaveName m0
	setdatafolder root:load
	killwaves/A
	setdatafolder root:
			
	DO_DtShw_GetSESAnaConInfo(m0)  //////////   Info derive for SES data matrix


End


Function DO_DtShw_SESBinary(m0,folderpath,dataname,igornum)
wave m0
String folderpath,dataname
Variable igornum

//	DFREF dfr = root:DataLoadFolder
//	SVAR dataname = dfr:GS_dataname
//	NVAR igormulti = dfr:DataOpen_SES_IgorMultiData
//	wave m0 = dfr:storeM0
	
	variable loaddatanum
	variable numinfolder
	string loadWaveName
	
	Newpath/O/Q pathtodata folderpath
	
	LoadWave/H/P=pathtodata/O/D/Q dataname
	print folderpath, dataname
	loadWaveName = StringfromList(0,S_waveNames)
//	loaddatanum = igornum  //specify the data from igorfile in which mulitiple data porentially stored
//	numinfolder =  CountObjects("root:load", 1)
//		if (loaddatanum<numinfolder)
//				loadWaveName = wavename ("",loaddatanum,4)
//		else
//				loadWaveName = wavename ("",0,4)
//		endif
			
//	setdatafolder root:
//	print loadWaveName
	duplicate/o $loadWaveName m0
	setwavelock 0, $loadWaveName
	killwaves $loadWaveName
			
//	DO_DtShw_GetSESAnaConInfo(m0)  //////////   Info derive for SES data matrix


End




Function DO_DtShw_setvar_NormChange(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_DtShw_DataUPdata()

End

Function DO_DtShw_setvar_filepath(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_DtShw_MListUPdata()
End


Function DO_DtShw_button_SESinfo(ctrlName) : ButtonControl
	String ctrlName

	Dowindow  SESinfo
	if (V_flag==0)
		Execute "SESinfo()"
	endif
	Dowindow/F  SESinfo

End

Function DO_DtShw_setvar_SetdataN(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:DataLoadFolder
	wave/t mnl = dfr:MNlist
	String MatName1
	MatName1 = mnl[varNum]
	SVAR dataname = dfr:GS_dataname
	dataname = MatName1
		
	DO_DtShw_DataUPdata()
	
End

Function DO_DtShw_button_UpFolder(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:DataLoadFolder
	SVAR folderpath = dfr:GS_folderpath1

	pathinfo/s tempath
	folderpath = s_path
	variable cond1 = cmpstr (s_path, "")
	if (cond1==0)
	return -1
	endif
	
	DO_DtShw_MListUPdata()

	wave/t mnl =dfr:MNlist
	String MatName1
	NVAR datanum= dfr:GV_datanum
	MatName1 = mnl[datanum]
	SVAR dataname= dfr:GS_dataname
	dataname = MatName1
	
End

Function DO_DtShw_setvar_finename(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_DtShw_DataUPdata()

End

Function DO_DtShw_button_DataLoad(ctrlName) : ButtonControl ////////  LoadData as a single mat
	String ctrlName

	DFREF dfr = root:DataLoadFolder
	wave m0 = dfr:storeM0
	wave sm = dfr:showM
	SVAR dataname = dfr:GS_dataname
	SVAR LoadMatHead = dfr:LoadMatHead
	String DestMatName
	String Numlist, NameList=""
	
	Numlist = DO_DtShw_ExtractDataNum(dataname) 
	//////////  ファイル名から候補の数字列を3つ選ぶ
	
	NameList= DO_DtShw_CandNameList(Numlist)
	//////////  ロードデータ名の候補(9個)を作成　
		
	NameList += "Enter by yourself"
	
	Variable namecase
	NVAR  ChoseOfCase = dfr:GV_ChoseOfCase
	NVAR	EnterCase = dfr:GV_EnterCase

	namecase = ChoseOfCase
	String message = "Chose a suggeted matrixname (1-9), or Enter by yourself (10)" 
	Prompt namecase, message, popup, NameList
	Doprompt "DataLoad", namecase
	
	if (namecase==1)
		DestMatName = stringfromlist (0, NameList)
		EnterCase = namecase
	elseif (namecase==2)
		DestMatName = stringfromlist (1, NameList)
		EnterCase = namecase
	elseif (namecase==3)
		DestMatName = stringfromlist (2, NameList)
		EnterCase = namecase
	elseif (namecase==4)
		DestMatName = stringfromlist (3, NameList)
		EnterCase = namecase
	elseif (namecase==5)
		DestMatName = stringfromlist (4, NameList)
		EnterCase = namecase
	elseif (namecase==6)
		DestMatName = stringfromlist (5, NameList)
		EnterCase = namecase
	elseif (namecase==7)
		DestMatName = stringfromlist (6, NameList)
		EnterCase = namecase
	elseif (namecase==8)
		DestMatName = stringfromlist (7, NameList)
		EnterCase = namecase
	elseif (namecase==9)
		DestMatName = stringfromlist (8, NameList)
		EnterCase = namecase
	elseif (namecase==10)
		DestMatName = stringfromlist ( (EnterCase-1), NameList)
		Prompt DestMatName, "Enter the matrixname to load"
		Doprompt "DataLoad", DestMatName
	endif
	
	ChoseOfCase = namecase

	if (V_Flag)
	return -1
	endif
	
	
	
	if (exists(DestMatName)==1)
		variable yesno
		Prompt yesno, "Do you surely overwite the matrix of ["+DestMatName + "] ?", popup, "yes;no"
		DoPrompt "Overwite", yesno
		
			if (V_Flag)
			return -1
			endif
		
		if (yesno==1)
			duplicate/o sm, $DestMatName
		elseif (yesno==2)
			return 0
		endif

	elseif(exists(DestMatName)==0)
	
		duplicate sm, $DestMatName
	
	endif
	
	////////////////////////  Add to Info_Wave //////////////////////////////////
	Variable CaseOfInfo
	NVAR  ChoseOfLoadCase = dfe:GV_ChoseOfLoadCase
	
	CaseOfInfo = ChoseOfLoadCase
	message= "Do you want to add the loaded matrix name into \"Info_wave\"?" 
	Prompt CaseOfInfo, message, popup, "No; Yes, add automatically; Yes, add by myself"
	Doprompt "DataLoad", CaseOfInfo
	if (V_Flag)
	return -1
	endif
	ChoseOfLoadCase = CaseOfInfo
	
	String WList, Wname
	WList = "X_base;Last_Wave;Offset_Wave;Bias_Wave;Angle;Info_Wave;Y_base;X_start_Wave;Start_Wave;memo;"
	
	Variable ii=0
		Do
			Wname = Stringfromlist(ii,WList)
			if (waveexists($WName)==0)
				Abort "You did not make graph tables and waves like \"Info_wave\" and so on!!"
				return -1
			endif
			ii+=1
		while (ii<10)
	
	wave/T Info_wave
	variable ii2
	
	if (CaseOfInfo==1)
		return -1
	endif
	
	if (CaseOfInfo==2)
		String TextWList = "Info_Wave;memo;"
		String NumericWList =  "Last_Wave;Offset_Wave;Bias_Wave;X_start_Wave;Start_Wave"
		Variable maxlastcell=-1, cell1
		
		ii=0
		Do 
			WName = Stringfromlist(ii,TextWList)
			cell1=	 DO_DtShw_LastOccupiedCell_TXT($Wname)
			if (maxlastcell<=cell1)
				maxlastcell = cell1
			endif
			ii+=1
		while (ii<2)
		
		ii=0
		Do 
			WName = Stringfromlist(ii,NumericWList)
			cell1=	 DO_DtShw_LastOccupiedCell($Wname)
			if (maxlastcell<=cell1)
				maxlastcell = cell1
			endif
			ii+=1
		while (ii<5)
		print maxlastcell
		DO_DtShw_RestLengthCheck(0,0, maxlastcell)  /// Graphtable内のwaveサイズが足りなければ増加
		
		ii2 = maxlastcell+1
		Info_wave [ii2] = DestMatName
		
		 DO_DtShw_AngleRecord(ii2,1)  ///////////////   Angle wave に、data note からの情報を書き込み
		
		 DO_GraT_ResizeGraphTable()	
	endif
	
	if (CaseOfInfo==3)
		message = "please enter the first cell number of Info_wave to dataload"
		Prompt maxlastcell, message
		Doprompt "Enter Number", maxlastcell
		
		Info_wave [maxlastcell] = DestMatName
		
		DO_DtShw_AngleRecord(maxlastcell,1) 
		 DO_GraT_ResizeGraphTable()
		
	endif
	
	
End

Function DO_DtShw_button_DataLoadMulti(ctrlName) : ButtonControl ////////  MultiLoadData
	String ctrlName
	
	DFREF dfr = root:DataLoadFolder

	NVAR LoadSN = dfr:GV_LoadSN
	NVAR LoadEN = dfr:GV_LoadEN
	variable sn,en
	
	sn = LoadSN
	en = LoadEN
	
	Prompt sn, "start number of rawdata set"
	Prompt en, "end number of rawdata set"
	Doprompt "Multiple data load", sn,en
	
	LoadSN = sn
	LoadEN = en
	
	if (V_Flag)
	return -1
	endif
	

	SVAR dataname = dfr:GS_dataname
	SVAR LoadMatHead = dfr:LoadMatHead
	String DestMatName
	String Numlist, NameList=""
	
	// NameList is a list of 9 candidates of way of naming to mateix for saving in igor
	Numlist = DO_DtShw_ExtractDataNum(dataname) 	
	NameList= DO_DtShw_CandNameList(Numlist)
		
	Variable namecase  // namecase is number of slected canditate
	//Variable/G GV_ChoseOfCase
	
	NVAR  ChoseOfCase = dfr:GV_ChoseOfCase
	//NVAR	EnterCase = dfr:GV_EnterCase

	namecase = ChoseOfCase

	String message = "Chose a naming format from suggested list" 
	Prompt namecase, message, popup, NameList
	Doprompt "DataLoad", namecase
	if (V_Flag)
	return -1
	endif
	
	
	ChoseOfCase = namecase



	////////////////////////  Data Load Routine //////////////////////////////////

	Variable ii
	wave m0 = dfr:storeM0 // original data
	wave sm = dfr:showM // normalized/combined data
	wave/T mnl = dfr:MNList
	String MatName1
	variable cond1 // flag for null cell in MNList

	ii = sn
	
	Do 
		MatName1 = mnl[ii]
		cond1 = cmpstr(MatName1,"")
		if(cond1==0)
			break
		endif
		
		// set the loading data file
		dataname = MatName1
		
		// make destnation matrix name following the naming above
		Numlist = DO_DtShw_ExtractDataNum(dataname) 
		NameList= DO_DtShw_CandNameList(Numlist)
		DestMatName = stringfromlist ((namecase-1), NameList)
	
		DO_DtShw_DataUPdata()
			
		if (exists(DestMatName)==1) // destnation matrix already exists
			variable yesno
			Prompt yesno, "Do you surely overwite the matrix of ["+DestMatName + "] ?", popup, "yes;no"
			DoPrompt "Overwite", yesno
		
			if (yesno==1) 
				duplicate/o sm, $DestMatName
				
				print dataname + " is overwrote to " + DestMatName

			elseif (yesno==2)
				return 0
			endif

		elseif(exists(DestMatName)==0) // destnation matrix is new
	
			duplicate sm, $DestMatName
			print dataname + " is loaded to " + DestMatName

	endif
	
//	Prompt yesno, "loop num is "+num2str(ii)+"will you continue ?", popup, "yes;no"
//	DoPrompt "query", yesno
//	if (yesno==2)
//	break
//	endif
	
	ii +=1
	while (ii<(en+1))
	
	NVAR datanum = dfr:GV_datanum
	datanum = ii-1
	DO_DtShw_DataUPdata()

	
	////////////////////////  Add to Info_Wave //////////////////////////////////
	NVAR  ChoseOfLoadCase = dfr:GV_ChoseOfLoadCase
	Variable CaseOfInfo
	CaseOfInfo = ChoseOfLoadCase
	message= "Do you want to add the loaded matrix name into \"Info_wave\"?" 
	Prompt CaseOfInfo, message, popup, "No; Yes, add automatically; Yes, add by myself"
	Doprompt "DataLoad", CaseOfInfo
	if (V_Flag)
	return -1
	endif
	ChoseOfLoadCase = CaseOfInfo
	
	
	String WList, Wname
	WList = "X_base;Last_Wave;Offset_Wave;Bias_Wave;Angle;Info_Wave;Y_base;X_start_Wave;Start_Wave;memo;"

	ii=0
		Do
			Wname = Stringfromlist(ii,WList)
			if (waveexists($WName)==0)
				Abort "You did not make graph tables and waves like \"Info_wave\" and so on!!"
				return -1
			endif
			ii+=1
		while (ii<10)
	
	wave/T Info_wave
	variable ii2
	

	if (CaseOfInfo==1)
		return -1
	endif
	
	if (CaseOfInfo==2)
		String TextWList = "Info_Wave;memo;"
		String NumericWList =  "Last_Wave;Offset_Wave;Bias_Wave;X_start_Wave;Start_Wave"
		Variable maxlastcell=-1, cell1
		
		ii=0
		Do 
			WName = Stringfromlist(ii,TextWList)
			cell1=	 DO_DtShw_LastOccupiedCell_TXT($Wname)
			if (maxlastcell<=cell1)
				maxlastcell = cell1
			endif
			ii+=1
		while (ii<2)
		
		ii=0
		Do 
			WName = Stringfromlist(ii,NumericWList)
			cell1=	 DO_DtShw_LastOccupiedCell($Wname)
			if (maxlastcell<=cell1)
				maxlastcell = cell1
			endif
			ii+=1
		while (ii<5)
		
		print maxlastcell
		DO_DtShw_RestLengthCheck(sn,en, maxlastcell)  /// Graphtable内のwaveサイズが足りなければ増加
		
		ii = sn
		ii2 = maxlastcell +1
		Do
			MatName1= mnl[ii]
			Numlist = DO_DtShw_ExtractDataNum(MatName1) 
			NameList= DO_DtShw_CandNameList(Numlist)
			DestMatName = stringfromlist ((namecase-1), NameList)
			 Info_wave [ii2] = DestMatName
			ii2+=1
		ii+=1
		while(ii<en+1)
		
		 DO_GraT_ResizeGraphTable()
		
	endif
	
	if (CaseOfInfo==3)
		message = "please enter the first cell number of Info_wave to dataload"
		Prompt maxlastcell, message
		Doprompt "Enter Number", maxlastcell
		
		DO_DtShw_RestLengthCheck(sn,en, (maxlastcell-1))  /// Graphtable内のwaveサイズが足りなければ増加

		ii=sn
		ii2=maxlastcell 
		Do
			MatName1= mnl[ii]
			Numlist = DO_DtShw_ExtractDataNum(MatName1) 
			NameList= DO_DtShw_CandNameList(Numlist)
			DestMatName = stringfromlist ((namecase-1), NameList)
			print DestMatName
			 Info_wave [ii2] = DestMatName
			ii2+=1
		ii+=1
		while(ii<en+1)				
		
		 DO_GraT_ResizeGraphTable()
		
	endif
	

	
	
End

Function DO_DtShw_button_done(ctrlName) : ButtonControl
	String ctrlName

	Dowindow/K DataShow
	
End

Function DO_DtShw_setvar_IgrDatNum(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_DtShw_DataUPdata()

End

Function DO_DtShw_check_NoiseRed(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:DataLoadFolder
	Variable/G dfr:DataOpen_flag_NR = checked	
	DO_DtShw_DataUPdata()

End

Function DO_DtShw_check_Combine(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:DataLoadFolder
	Variable/G dfr:DataOpen_flag_comb = checked	
	DO_DtShw_DataUPdata()

End

Function DO_DtShw_check_Normalize(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:DataLoadFolder
	NVAR flag = dfr:DataOpen_flag_Norm
	flag = checked	
	DO_DtShw_DataUPdata()

End

Function DO_DtShw_button_SESInfoClose(ctrlName) : ButtonControl
	String ctrlName

	Dowindow/K SESinfo
	
End

Function DO_DtShw_button_pathset(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:DataLoadFolder
	SVAR folderpath = dfr:GS_folderpath1
	newpath/O tempath 
	if (V_flag)
	return -1
	endif
	pathinfo/s tempath
	folderpath = s_path
	
	DO_DtShw_MListUPdata()
	
end



//Function DataOpen_GetA1_ScanEnergy(headerwave)
//wave/T headerwave

	//String testStr	
	//variable ii=0, listnum =80
	//variable startE, stepE
	
	//Variable/G DataOpen_A1StartE
	//Variable/G DataOpen_A1StepE

	
	//Do
		//testStr = headerwave[ii]
			 	
			//if (GrepString(testStr,"(?i)Step Size"))
				//sscanf testStr, " Step Size %f", stepE
			//endif
//			if (GrepString(testStr,"(?i)Start K.E."))
//				sscanf testStr, "Start K.E. %f", startE
//			endif
			
//		ii = ii +1
//	while(ii < listnum)
	
//	DataOpen_A1StartE = startE
//	 DataOpen_A1StepE = stepE
//end

//Function DataOpen_A1DataType(w)
//wave w

//	variable test1,test2
//	variable startE, stepE
	
//	Variable/G DataOpen_A1StartE
//	Variable/G DataOpen_A1StepE

//	startE = DataOpen_A1StartE
//	stepE = DataOpen_A1StepE
	
//	test1= w[0][0]
//	test2 = w[1][0]
	
//	if ((test1==startE)&&(test2==(startE+stepE)))
//		 print "data is normal mode"
//		  DeletePoints/M=1 0,1, w
//	endif	 
//end




////////////////////  DataShowIGOR  (Igor file からの読み込み) /////////////////////
////////////////////  読み込みデータはmatrixのみ /////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////



Window DataShowIGOR() : 
	PauseUpdate; Silent 1		// building window...
	DO_Igr_SetUPDataLoadIGOR()
	Display /W=(681,133,1097,408)
	AppendImage :DataLoadFolder:showMIg
	ModifyImage showMIg ctab= {*,*,Terrain,0}
	ModifyGraph cbRGB=(65535,43690,0)
	ModifyGraph mirror=2
	ControlBar 41
	SetVariable setvar0,pos={6.00,3.00},size={340.00,15.00},title=" ",font="Osaka"
	SetVariable setvar0,value= root:DataLoadFolder:GS_filepath_ig
	Button button0,pos={359.00,3.00},size={50.00,16.00},proc=DO_Igr_button_igorfileread,title="IGOR file"
	Button button0,font="Helvetica",fSize=9,fColor=(16385,65535,41303)
	TitleBox title0,pos={7.00,22.00},size={92.00,16.00}
	TitleBox title0,labelBack=(57346,65535,49151),font="Osaka",frame=0
	TitleBox title0,fColor=(0,0,65535)
	TitleBox title0,variable= root:DataLoadFolder:GS_filename_ig,anchor= LC,fixedSize=1
	SetVariable setvar1,pos={106.00,22.00},size={43.00,14.00},proc=DO_Igr_setvar_SetDataN,title=" "
	SetVariable setvar1,value= root:DataLoadFolder:GV_datanum_ig
	SetVariable setvar2,pos={148.00,22.00},size={103.00,16.00},proc=DO_Igr_setvar_Filename,title=" "
	SetVariable setvar2,font="Helvetica",fSize=12
	SetVariable setvar2,value= root:DataLoadFolder:GS_dataname_ig
	Button button1,pos={256.00,22.00},size={43.00,16.00},proc=DO_Igr_button_DataLoad,title="load"
	Button button1,fSize=10,fColor=(0,65535,0)
	SetVariable setvar3,pos={302.00,21.00},size={66.00,14.00},title=" "
	SetVariable setvar3,valueBackColor=(0,65535,0)
	SetVariable setvar3,value= root:DataLoadFolder:LoadMatHead_ig
	Button button2,pos={373.00,21.00},size={32.00,16.00},proc=DO_Igr_button_done,title="done"
	Button button2,fSize=10,fColor=(65535,0,0)
EndMacro

Function DO_Igr_SetUPDataLoadIGOR()
	
	if (DataFolderRefStatus(dfr) ==0)
		NewDataFolder/O root:DataLoadFolder
	endif
	DFREF dfr = root:DataLoadFolder
	
	// path変数の定義
	String/G dfr:GS_filepath_ig
	// matrix number,nameの定義
	Variable/G dfr:GV_datanum_ig
	String/G dfr:GS_dataname_ig
	String/G dfr:GS_filename_ig
 	//showM, storeM0の定義	
	make/d/o/N=(501,501) dfr:showMIg 
	SetScale/P x 0,0.01,"", dfr:showMIg
	SetScale/P y 0,0.01,"", dfr:showMIg
	wave shwig = dfr:showMIg
	shwig=100000*(sin(pi*(p/500)*3)+1)*(sin(pi*(q/500)*3)+1)
	duplicate/o dfr:showMIg dfr:storeMIg0

	//MatrixList
	Make/O/T/N=1000 dfr:MNList_Ig
	// LoadData関係
	String/G dfr:LoadMatHead_ig="IGmat"
	Variable/G dfr:GV_ChoseOfCase_ig=1
	Variable/G dfr:GV_EnterCase_ig=1

	
Endmacro


Function DO_Igr_button_igorfileread(ctrlName) : ButtonControl
	String ctrlName

	DFREF dfr = root:DataLoadFolder

	Variable refNum
	String outputPath
	SVAR filepath_ig = dfr:GS_filepath_ig
	SVAR filename_ig = dfr:GS_filename_ig
	String fileFilters = "Igor Files (*.pxt,*.pxp):.pxt,.pxp" 
	
	Open /D /R /F=fileFilters refNum	
	filepath_ig= S_fileName
	//print filepath_ig
	filename_ig = ParseFilePath(0,filepath_ig,":",1,0)

	
	DO_Igr_DataListUpdate()
	
	
	wave/t mnl = dfr:MNlist_Ig
	String MatName
	NVAR datanum_ig = dfr:GV_datanum_ig
	MatName = mnl[datanum_ig]
	SVAR dataname_ig = dfr:GS_dataname_ig
	dataname_ig = MatName
	
	DO_Igr_DataUpdate()
	
	
End

Function DO_Igr_DataListUpdate()
	String filename
	String pathname
	
	DFREF dfr = root:DataLoadFolder
	SVAR filepath_ig = dfr:GS_filepath_ig
	SVAR filename_ig = dfr:GS_filename_ig
	
	pathname = removeending (filepath_ig, filename_ig)
	filename = filename_ig
	
	setdatafolder root:
	newdatafolder/o  loadpack
	
	NewPath/O/Q tempath pathname
	LOADDATA /p=tempath/q /T=loadpack/L=1/O filename_ig
	
	wave/T mnl = dfr:MNList_Ig
	String Matname
	String Mlist
	setdatafolder root:loadpack
	Mlist=WaveList("*",";","DIMS:2,TEXT:0")
	
	mnl=""
	Variable ii
	ii=0
	Do
		MatName=stringfromlist(ii,Mlist)
		mnl[ii]=MatName
		ii+=1
	while(cmpstr(MatName,"")!=0)
	
	killwaves/A		
	setdatafolder root:

End


Function DO_Igr_DataUpdate()
	String filename
	String pathname
	String dataname
	
	DFREF dfr = root:DataLoadFolder
	SVAR filepath_ig = dfr:GS_filepath_ig
	SVAR filename_ig = dfr:GS_filename_ig
	SVAR dataname_ig = dfr:GS_dataname_ig
	wave m0 = dfr:storeMIg0
	wave shwmig = dfr:showMIg
	
	pathname = removeending (filepath_ig, filename_ig)
	filename = filename_ig
	dataname = dataname_ig
	
	
	if (cmpstr(dataname_ig,"")!=0)
		NewPath/O/Q tempath pathname
		LOADDATA /p=tempath/q /T=loadpack/L=1/O/J=dataname filename_ig
	
		setdatafolder root:
		duplicate/o root:loadpack:$dataname m0	
		duplicate/o m0 shwmig
		
		setdatafolder root:loadpack
		killwaves/A
		setdatafolder root:
	else
		m0 = 0
		shwmig = 0
	endif

End

Function DO_Igr_setvar_SetDataN(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:DataLoadFolder

	wave/t mnl = dfr:MNlist_Ig
	String MatName
	MatName = mnl[varNum]
	SVAR dataname_ig = dfr:GS_dataname_ig
	dataname_ig = MatName
	
	DO_Igr_DataUpdate()

End

Function DO_Igr_setvar_Filename(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_Igr_DataUpdate()

End


Function DO_Igr_button_DataLoad(ctrlName) : ButtonControl
	String ctrlName

	DFREF dfr = root:DataLoadFolder
	wave m0 = dfr:storeMIg0
	SVAR dataname_ig = dfr:GS_dataname_ig
	SVAR head = dfr:LoadMatHead_ig
	String DestMatName
	String Numlist
	String Namelist=""
	String sname
	
	
	///////////// 第1候補 //////////////////
	
	sname = dataname_ig 
	Namelist += sname + ";"
	
	
	///////////// 第2候補 //////////////////
	SVAR filename_ig = dfr:GS_filename_ig
	String filename
	variable iii=0
	filename =  filename_ig
	
	if (stringmatch(filename,"*.pxt")==1||stringmatch(filename,"*.pxp")==1)  
		Do
			filename=removeending(filename)
			iii+=1
		while(iii<4)		
	endif
	
	sname = filename+ "_" + dataname_ig 
	Namelist += sname + ";"
	
	
	//////////////第3,4候補//////////////////
	
	Numlist = DO_DtShw_ExtractDataNum(dataname_ig)
	
	
	Variable ii=0,sl
	Variable cond1
	String sn,sn0
	
	Do
		sn = stringfromlist (ii, Numlist)
		cond1 = cmpstr(sn,"")
		
		if (cond1==1)
			sl = strlen(sn)
			if (sl>3)
				sn0=sn[sl-4,sl-1]
			endif
		
			if (sl==3)
				sn0="0"+sn
			elseif (sl==2)
				sn0="00"+sn
			elseif (sl==1)
				sn0="000"+sn
			endif
			
			Sname = head + sn0
		
		else
			Sname ="NoCandidate"
		endif
		
		
		NameList +=  Sname + ";"
		
		ii=ii+1
		
	while (ii<2)
		

	
	NameList += "Enter by yourself"
	
//	print NameList
	
	Variable CaseOfName
	NVAR  ChoseOfCase_ig = dfr:GV_ChoseOfCase_ig
	NVAR EnterCase_ig = dfr:GV_EnterCase_ig

	CaseOfName = ChoseOfCase_ig
		
	String message = "Chose a suggeted matrixname (1-4), or Enter by yourself (5)" 
	Prompt CaseOfName, message, popup, NameList
	Doprompt "DataLoad", CaseOfName
	
	
	if (CaseOfName==1)
		DestMatName = stringfromlist (0, NameList)
		EnterCase_ig = CaseOfName
	elseif (CaseOfName==2)
		DestMatName = stringfromlist (1, NameList)
		EnterCase_ig = CaseOfName
	elseif (CaseOfName==3)
		DestMatName = stringfromlist (2, NameList)
		EnterCase_ig = CaseOfName
	elseif (CaseOfName==4)
		DestMatName = stringfromlist (3, NameList)
		EnterCase_ig = CaseOfName
	elseif (CaseOfName==5)
		DestMatName = stringfromlist ( (EnterCase_ig-1), NameList)
		Prompt DestMatName, "Enter the matrixname to load"
		Doprompt "DataLoad", DestMatName
	endif
	
	ChoseOfCase_ig = CaseOfName
	
	if (exists(DestMatName)==1)
		variable yesno
		Prompt yesno, "Do you surely overwite the matrix of ["+DestMatName + "] ?", popup, "yes;no"
		DoPrompt "Overwite", yesno
		
		if (yesno==1)
			duplicate/o m0, $DestMatName
		elseif (yesno==2)
			DestMatName = stringfromlist ( (EnterCase_ig-1), NameList)
			Prompt DestMatName, "Enter the matrixname to load"
			Doprompt "DataLoad", DestMatName
			duplicate m0, $DestMatName
		endif

	elseif(exists(DestMatName)==0)
	
		duplicate m0, $DestMatName
	
	endif
	
End





Function DO_Igr_button_done(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow/K DataShowIGOR
	
End







////////////////////////////////   WavesShow  Macro     //////////////////////////////////
////////////////////////////////////////////////////////////////////////////.///////////
////////////////////////////////////////////////////////////////////////////////////////

Window WavesShow()
	PauseUpdate; Silent 1		// building window...
	DO_ShwW_SetupShowM()
	Display /W=(430,141,892,461)
	AppendImage :DataLoadFolder:showM2
	ModifyImage showM2 ctab= {*,*,Terrain,0}
	ModifyGraph cbRGB=(49151,65535,49151),frameInset=4
	ModifyGraph mirror=2
	ControlBar 56
	GroupBox group0,pos={173,7},size={236,42},labelBack=(55961,61291,65535)
	GroupBox group0,font="Helvetica"
	SetVariable setvar0,pos={6,10},size={46,15},proc=DO_ShwW_setvar_setN_global,title=" "
	SetVariable setvar0,font="Helvetica",fSize=12,value= root:DataLoadFolder:ShowW_matnum
	SetVariable setvar1,pos={52,10},size={91,15},proc=DO_ShwW_setvar_DataName_global,title=" "
	SetVariable setvar1,font="Helvetica",fSize=12,value= root:DataLoadFolder:ShowW_MN
	Button button2,pos={177,11},size={43,16},proc=DO_ShwW_button_ShowEDC,title="EDC"
	Button button2,fColor=(49151,53155,65535)
	SetVariable setvar2,pos={223,12},size={40,12},proc=DO_ShwW_setvar_EDCcom,title="c"
	SetVariable setvar2,font="Helvetica",limits={0,1000,1},value= root:DataLoadFolder:ShowW_comb
	SetVariable setvar3,pos={265,12},size={63,12},proc=DO_ShwW_setvar_EDCcom,title="of"
	SetVariable setvar3,font="Helvetica",limits={-inf,inf,1000},value= root:DataLoadFolder:ShowW_offset
	SetVariable setvar6,pos={331,12},size={47,12},proc=DO_ShwW_setvar_EDCcloseUP,title="w"
	SetVariable setvar6,font="Helvetica",limits={0,1000,1},value= root:DataLoadFolder:ShowW_winnum
	SetVariable setvar4,pos={7,30},size={42,15},proc=DO_ShwW_setvar_DataName_GraT,title=" "
	SetVariable setvar4,value= root:DataLoadFolder:ShowW_Gmatnum
	SetVariable setvar5,pos={48,30},size={54,15},title=" "
	SetVariable setvar5,value= root:DataLoadFolder:ShowW_GMN,noedit= 1
	SetVariable setvar7,pos={103,31},size={46,12},title="ang",font="Helvetica"
	SetVariable setvar7,limits={-inf,inf,0},value= root:DataLoadFolder:ShowW_ang,noedit= 1
	Button button3,pos={178,30},size={43,16},proc=DO_ShwW_button_ShowMDC,title="MDC"
	Button button3,fColor=(49151,53155,65535)
	SetVariable setvar8,pos={224,31},size={40,12},proc=DO_ShwW_setvar_MDCcom,title="c"
	SetVariable setvar8,font="Helvetica",value= root:DataLoadFolder:ShowW_combM
	SetVariable setvar9,pos={265,31},size={63,12},proc=DO_ShwW_setvar_MDCcom,title="of"
	SetVariable setvar9,font="Helvetica"
	SetVariable setvar9,limits={-inf,inf,10000},value= root:DataLoadFolder:ShowW_offsetM
	SetVariable setvar10,pos={332,31},size={47,12},proc=DO_ShwW_setvar_MDCcloseup,title="w"
	SetVariable setvar10,font="Helvetica",value= root:DataLoadFolder:ShowW_winnumM
	Button button0,pos={414,12},size={35,16},proc=DO_ShwW_button_doneAll,title="done"
	Button button0,font="Helvetica",fSize=10,fColor=(65535,0,0)
	Button button1,pos={377,11},size={15,16},proc=DO_ShwW_button_doneEDC,title="d"
	Button button1,font="Helvetica",fSize=8,fColor=(65535,0,0)
	Button button4,pos={377,29},size={15,16},proc=DO_ShwW_button_doneMDC,title="d"
	Button button4,font="Helvetica",fSize=8,fColor=(65535,0,0)
	Button button5,pos={413,33},size={35,16},proc=DO_ShwW_button_NormPanel,title="norm"
	Button button5,font="Helvetica Light",fSize=9,fColor=(48059,48059,48059)
	Button button6,pos={393,11},size={15,16},proc=DO_ShwW_button_SaveEDCs,title="s"
	Button button6,font="Helvetica",fSize=8,fColor=(32768,40777,65535)
	Button button7,pos={149,9},size={22,16},proc=DO_ShwW_button_ShowMatNewWin,title="Shw"
	Button button7,fSize=7,fColor=(16385,65535,65535)
	Button button8,pos={149,29},size={22,16},proc=DO_ShwW_button_ImageProf,title="Prf"
	Button button8,fSize=7,fColor=(16385,65535,65535)
	SetDrawLayer UserFront
	DrawRect 0.440414507772021,-0.381818181818182,1.01813471502591,-0.277272727272727
EndMacro


Function DO_ShwW_SetupShowM()
	
	if (DataFolderRefStatus(dfr) ==0)
		NewDataFolder/O root:DataLoadFolder
	endif
	
	DFREF dfr = root:DataLoadFolder

	Variable/G dfr:ShowW_matnum 
	String/G dfr:ShowW_MN 
	Variable/G dfr:ShowW_Fmatnum
	String/G dfr:ShowW_FMN
	Variable/G dfr:ShowW_Gmatnum
	String/G dfr:ShowW_GMN
	Variable/G dfr:ShowW_ang
	String/G dfr:ShowW_StoreMN 
	String/G dfr:ShowW_origMN
	Variable/G dfr:ShowW_Norm_flag=0
		
	make/d/o/N=(501,501) dfr:showM2
	SetScale/P x 0,0.01,"", dfr:showM2
	SetScale/P y 0,0.01,"", dfr:showM2
	wave sm2 = dfr:showM2
	sm2=100000*(sin(pi*(p/500)*10)+1)*(sin(pi*(q/500)*10)+1)
	duplicate/o sm2 dfr:storeM1, dfr:storeM2

	//MatrixList
	Make/O/T/N=1000 dfr:ShowW_MNList
	DO_ShwW_MatrixListIndex()


  //表示する積分lineの定義
	Variable/G dfr:ShowW_Mcen=2, dfr:ShowW_Mwid=1
	make/d/o/N=501 dfr:ShowW_lineA, dfr:ShowW_lineB
	SetScale/P x 0,0.01,"", dfr:ShowW_lineA
	SetScale/P x 0,0.01,"", dfr:ShowW_lineB
	NVAR mcen = dfr:ShowW_Mcen
	NVAR mwid = dfr:ShowW_Mwid
	Wave linA = dfr:ShowW_lineA
	Wave linB = dfr:ShowW_lineB
	linA = mcen -  mwid/2
	linB = mcen +  mwid/2

	
	// グラフ名の定義
//	String/G GN_graph="arpes"	
//	variable/G Vflag_offset, V_offset
	
	
	//temp waves window
	Variable/G  dfr:ShowW_comb=1
	Variable/G  dfr:ShowW_offset=1000
	Variable/G  dfr:ShowW_winnum=0
	Variable/G  dfr:ShowW_combM =10
	Variable/G  dfr:ShowW_offsetM = 10000
	Variable/G  dfr:ShowW_winnumM=0
	
	//saving waves
	Variable/G dfr:ShowW_Qedcmdc
	Variable/G dfr:ShowW_Qgraph
	Variable/G dfr:ShowW_Qreverse
	Variable/G dfr:ShowW_startwnum
	String/G dfr:ShowW_wavehead
	String/G dfr:ShowW_infoname
	String/G dfr:ShowW_str1
	String/G dfr: ShowW_str2
	
	//Normalization
	Variable/G dfr:ShowW_WSnormWin_ini=0
	
	Variable/G dfr:ShowW_MList_flag = 2
	Variable/G dfr:ShowW_flag_NR= 0
	Variable/G dfr:ShowW_NR_sp = 0
	Variable/G dfr:ShowW_NR_ep = 100
	Variable/G dfr:ShowW_condfactor = 1.1
	Variable/G dfr:ShowW_flag_comb = 0
	Variable/G dfr:ShowW_comb_x = 1
	Variable/G dfr:ShowW_comb_y = 1
	Variable/G dfr:ShowW_flag_Norm = 0
	Variable/G dfr:ShowW_Norm_sr = 0
	Variable/G dfr:ShowW_Norm_er = 100
	Variable/G dfr:ShowW_flag_MNorm = 0
	Variable/G dfr:ShowW_MNorm_sr = 0
	Variable/G dfr:ShowW_MNorm_er = 100
	
		
	//wave nameの定義
	String/G dfr:WN_base="SiCwave_"


End







Function DO_ShwW_MatrixListIndex()

	DFREF dfr = root:DataLoadFolder
	String Mlist
	String MatName1
	Variable ii, jj, flag
	wave/T mnl = dfr:ShowW_MNList
	variable cond1
	
	Mlist=WaveList("*",";","DIMS:2,TEXT:0")
	ii=0
	jj=0
	Do
		MatName1=stringfromlist(ii,Mlist)
		flag = cmpstr(MatName1,"showM2")
		if (flag==0)
			jj = ii
			ii+=1
		else		
			mnl[ii]=MatName1
			ii+=1
		endif
		MatName1=stringfromlist(ii,Mlist)
	while(cmpstr(MatName1,"")!=0)
	
	//DeletePoints jj,1, mnl


end




Function DO_ShwW_DataUPdate()

	DFREF dfr = root:DataLoadFolder
	SVAR sw_MN  = dfr:ShowW_MN 
	wave sm2 = dfr:showM2
	wave m2 = dfr:storeM2
	Wave linA = dfr:ShowW_lineA
	Wave linB = dfr:ShowW_lineB
	variable xstart, xdelta, xrange
	
	if (waveexists($sw_MN)==1)
		duplicate/o $sw_MN sm2 
//		xstart =  dimoffset ( showM2 ,0)
//		xdelta = dimdelta ( showM2 ,0)
	//	xrange =  ((dimsize ( showM2 ,0)-1)*dimdelta ( showM2 ,0))
	//  SetScale/I x (xstart),(xrange+xstart),"", ShowW_lineA
	//	SetScale/I x (xstart),(xrange+xstart),"", ShowW_lineB	
	else
		sm2=0
	endif	
	duplicate/o sm2 m2
End


////  ShowEDC
Function DO_ShwW_button_ShowEDC(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow  TmpWave
	if (V_flag==0)
		Display/N=TmpWave
		DO_ShwW_TmpEDCUpdate("TmpWave")
	else
		Dowindow/F  TmpWave
		Do_ShoW_ClearAllwaves("TmpWave")
		DO_ShwW_TmpEDCUpdate("TmpWave")
	endif
	
	Dowindow/F  EDCpick

End


////  ShowMDC
Function DO_ShwW_button_ShowMDC(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow  TmpWaveMDC
	if (V_flag==0)
		Display/N=TmpWaveMDC
		DO_ShwW_TmpMDCUpdate("TmpWaveMDC")
	else
		Dowindow/F  TmpWaveMDC
		Do_ShoW_ClearAllwaves("TmpWaveMDC")
		DO_ShwW_TmpMDCUpdate("TmpWaveMDC")
		
	endif
	
	Dowindow/F  MDCpick


End


Function DO_ShwW_TmpEDCUpdate(windowname)
String windowname

	DFREF dfrF,dfr
	if (DataFolderRefStatus(dfrF) ==0)
		NewDataFolder/O root:DataOpenF
	endif
	DFREF dfrF = root:DataOpenF
	DFREF dfr = root:DataLoadFolder

	NVAR  sw_comb = dfr:ShowW_comb
	NVAR  sw_offset = dfr:ShowW_offset
	
	wave sm2 = dfr:showM2
	Variable xdim, ydim
	Variable xstart, xdelta
	Variable Num_wave
	Variable offset=0
	

	xdim=Dimsize(sm2,0)
	ydim=Dimsize(sm2,1)
	xstart=Dimoffset(sm2,0)
	xdelta=Dimdelta(sm2,0)
	if (sw_comb>0)
		Num_wave=floor(ydim/sw_comb)
	elseif (sw_comb==0)
		Num_wave=1
	endif

	String Yhead = "tmp"
	String wname
	
	pauseupdate; silent 1

	Variable ii=0
	Do
		wname=Yhead+num2str(ii)
		Make/N=(xdim)/D/O dfrF:$wname
		wave tmpw = dfrF:$wname
		DO_ShwW_EDCfunc(tmpw,sm2,sw_comb, ii)
	
		SetScale/P x xstart,xdelta,"", tmpw
		appendtograph/W=$windowname tmpw
		offset = ii *  sw_offset
		ModifyGraph/W=$windowname offset($wname)={0,offset}
		ii+=1
	while(ii<Num_wave)

End
	
Function DO_ShwW_EDCfunc(wavename,matname,Num_combine,i)
wave wavename,matname
variable Num_combine,i
variable ysize
variable j=0

	wavename=0
	if (Num_combine>0)
		Do
			wavename[]+=matname[p][i*Num_combine+j]
			j+=1
		while(j<Num_combine)
	elseif (Num_combine==0)
		ysize = dimsize(matname,1)
		Do
			wavename[]+=matname[p][j]
			j+=1
		while(j<ysize)
	endif

end

Function  Do_ShoW_ClearAllwaves(windowname)
String windowname
	
	
	String WList
	String Wname
	variable ii
	
	WList =Tracenamelist(windowname, ";",1)
	ii=0
	Do
		Wname = stringfromlist(ii,WList)
		RemoveFromGraph/W=$windowname $Wname
	ii+=1
		Wname = stringfromlist(ii,WList)
	while(cmpstr(Wname,"")!=0)

End


Function DO_ShwW_setvar_EDCcom(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	Dowindow  TmpWave
	if (V_flag==1)
		Do_ShoW_ClearAllwaves("TmpWave")
		DO_ShwW_TmpEDCUpdate("TmpWave")
	endif		
End


Function DO_ShwW_setvar_4old(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:DataLoadFolder

	DO_DtShw_MListUPdata()
	
	wave/t mnl = dfr:MNList
	String MatName1
	MatName1 = mnl[varNum]
	//String/G ShowW_FMN
	SVAR sw_FMN = dfr:ShowW_FMN
	sw_FMN = MatName1
	
	DO_ShwW_DataUPdateF()
	
	Dowindow  TmpWave
	if (V_flag==1)
		Do_ShoW_ClearAllwaves("TmpWave")
		DO_ShwW_TmpEDCUpdate("TmpWave")
	endif		
End


Function 	DO_ShwW_DataUPdateF()

	DFREF dfr = root:DataLoadFolder

	SVAR sw_FMN = dfr:ShowW_FMN
	SVAR folderpath = dfr:GS_folderpath1
	wave m0 = dfr:storeM0
	wave sm2 = dfr:showM2
	
	PauseUpdate; Silent 1
	//string filename
	//filename = GS_folderpath1+ShowW_FMN
	NewPath/O/Q tempath folderpath
	getfilefolderinfo/P=tempath/Q  sw_FMN
	
	if (V_isFile==0)   // if data of dataname exists, V_isFile==1
		m0=0
		return -1
	endif	
	
	//////////  A1 data loading   ////////////////////

		if ((stringmatch(sw_FMN,"*.txt")==1)||(stringmatch(sw_FMN,"*.mot")==1)) //  A1 data loading  (txt/mot) 

			DO_DtShw_A1txt2D(m0,folderpath,sw_FMN)
		
		endif
		
				
		if (stringmatch(sw_FMN,"*.krx")==1) 	//  A1 data loading  (krx)   
		
			DO_DtShw_krxfile2D(m0,folderpath,sw_FMN)
			
		endif
	//////////  SES data loading   ////////////////////

		NVAR ses_igormulti = dfr:DataOpen_SES_IgorMultiData

		if (stringmatch(sw_FMN,"*.pxt")==1)			/// SES data loading  
			
			DO_DtShw_SES2D(m0,folderpath,sw_FMN,ses_igormulti)
			
		elseif (stringmatch(sw_FMN,"*.pxp")==1)
			
			DO_DtShw_SES2D(m0,folderpath,sw_FMN,ses_igormulti)
		
		endif
		

	duplicate/o m0 sm2




End


Function DO_ShwW_EDCcloseUP(wnum)
variable wnum

	DFREF dfr = root:DataOpenF
	if (DataFolderRefStatus(dfr) !=0)
	SetDataFolder  dfr
	variable cond
	
	
	String Wlist = wavelist("tmp*",";","")
	String tmpname = stringfromlist(wnum,Wlist)
	String  tmpname1 = stringfromlist(wnum-2,Wlist)
	cond= cmpstr(tmpname1,"")
	if (cond==0)
		tmpname1 = tmpname
	endif
	String  tmpname2 = stringfromlist(wnum-1,Wlist)
	cond= cmpstr(tmpname2,"")
	if (cond==0)
		tmpname2= tmpname
	endif
	String  tmpname3 = stringfromlist(wnum+1,Wlist)
	cond= cmpstr(tmpname3,"")
	if (cond==0)
		tmpname3= tmpname
	endif
		String  tmpname4 = stringfromlist(wnum+1,Wlist)
	cond= cmpstr(tmpname4,"")
	if (cond==0)
		tmpname4= tmpname
	endif
	
		String tracelist
		cond= cmpstr(tmpname,"")
		if (cond==1)
			Dowindow TmpWave
			if(V_flag==1)
				tracelist = TraceNameList("TmpWave", ";", 1)
				if (grepstring(tracelist,tmpname)==1)
				ModifyGraph/W=TmpWave lsize=1
				ModifyGraph/W=TmpWave lsize($tmpname)=2
				endif
			endif
			duplicate/o $tmpname edcy
			duplicate/o $tmpname1 edcy1
			duplicate/o $tmpname2 edcy2
			//	duplicate/o $tmpname3 edcy3
			//	duplicate/o $tmpname4 edcy4
		
			Dowindow EDCpick
			if (V_flag==0)
				display/N=EDCpick edcy
				appendtograph/W=EDCpick edcy1, edcy2//, edcy3,edcy4
				ModifyGraph rgb(edcy1)=(65535,54611,49151)
				ModifyGraph rgb(edcy2)=(65535,54611,49151)
//				ModifyGraph rgb(edcy3)=(65535,54611,49151)
//				ModifyGraph rgb(edcy4)=(65535,54611,49151)
				ReorderTraces edcy,{edcy1,edcy2}
			endif	
		endif
		
	endif
	
	///////////////  Fit用にroot folderにもedcyを作成
	duplicate/o edcy root:edcy
	/////////////////////////////////////////////
	
	SetDataFolder  root:

End


Function DO_ShwW_setvar_EDCcloseUP(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_ShwW_EDCcloseUP(varNum)
	
End





Function DO_ShwW_TmpMDCUpdate(windowname)
	String windowname
	
	DFREF dfr = root:DataLoadFolder
	NVAR  sw_combM = dfr:ShowW_combM
	NVAR  sw_offsetM = dfr:ShowW_offsetM
	//Variable/G  ShowW_combM
	//Variable/G  ShowW_offsetM
	
	DFREF dfrF
	if (DataFolderRefStatus(dfrF) ==0)
		NewDataFolder/O root:DataOpenF
	endif
	DFREF dfrF= root:DataOpenF

	//wave showM2
	wave sm2 = dfr:showM2
	Variable xdim, ydim
	Variable ystart, ydelta
	Variable Num_wave
	Variable offset=0
	

	xdim=Dimsize(sm2,0)
	ydim=Dimsize(sm2,1)
	ystart=Dimoffset(sm2,1)
	ydelta=Dimdelta(sm2,1)
	if (sw_combM>0)
		Num_wave=floor(xdim/sw_combM)
	elseif (sw_combM==0)
		Num_wave=1
	endif

	String Yhead = "MDCtmp"
	String wname
	
	pauseupdate; silent 1

	Variable ii=0
	Do
		wname=Yhead+num2str(ii)
		Make/N=(ydim)/D/O dfrF:$wname
				
		DO_ShwW_MDCfunc(dfrF:$wname,sm2,sw_combM, ii)
	
		SetScale/P x ystart,ydelta,"", dfrF:$wname
		appendtograph/W=$windowname dfrF:$wname
		offset = ii *  sw_offsetM
		ModifyGraph/W=$windowname offset($wname)={0,offset}
		ii+=1
	while(ii<Num_wave)

End
	
	
Function DO_ShwW_MDCfunc(wavename,matname,Num_combine,i)
wave wavename,matname
variable Num_combine,i
variable xsize
variable j=0

	wavename=0
	if (Num_combine>0)
		Do
			wavename[]+=matname[i*Num_combine+j][p]
			j+=1
		while(j<Num_combine)
	elseif (Num_combine==0)
		xsize = dimsize(matname,0)
		Do
			wavename[]+=matname[j][p]
			j+=1
		while(j<xsize)
	endif

end


Function DO_ShwW_setvar_MDCcom(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	Dowindow  TmpWaveMDC
	if (V_flag==1)
		Do_ShoW_ClearAllwaves("TmpWaveMDC")
		DO_ShwW_TmpMDCUpdate("TmpWaveMDC")
	endif		
End


Function DO_ShwW_setvar_MDCcloseup(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	Do_ShwW_MDCcloseUP(varNum)
	
End


Function Do_ShwW_MDCcloseUP(wnum)
variable wnum

	DFREF dfr = root:DataOpenF
	if (DataFolderRefStatus(dfr) !=0)
	variable cond
	SetDataFolder  dfr

	String Wlist = wavelist("MDCtmp*",";","")
	String tmpname = stringfromlist(wnum,Wlist)
	String  tmpname1 = stringfromlist(wnum-2,Wlist)
	cond= cmpstr(tmpname1,"")
	if (cond==0)
		tmpname1 = tmpname
	endif
	String  tmpname2 = stringfromlist(wnum-1,Wlist)
	cond= cmpstr(tmpname2,"")
	if (cond==0)
		tmpname2= tmpname
	endif
	String  tmpname3 = stringfromlist(wnum+1,Wlist)
	cond= cmpstr(tmpname3,"")
	if (cond==0)
		tmpname3= tmpname
	endif
		String  tmpname4 = stringfromlist(wnum+1,Wlist)
	cond= cmpstr(tmpname4,"")
	if (cond==0)
		tmpname4= tmpname
	endif
	
	cond= cmpstr(tmpname,"")
	String tracelist
	
	if (cond==1)
		Dowindow TmpWaveMDC
		if(V_flag==1)
			tracelist = TraceNameList("TmpWaveMDC", ";", 1)
			if (grepstring(tracelist,tmpname)==1)
			ModifyGraph/W=TmpWaveMDC lsize=1
			ModifyGraph/W=TmpWaveMDC lsize($tmpname)=2
			endif
		endif
		duplicate/o $tmpname mdcy
		duplicate/o $tmpname1 mdcy1
		duplicate/o $tmpname2 mdcy2

		
		Dowindow MDCpick
		if (V_flag==0)
			display /W=(862,219,1280,438)/N=MDCpick mdcy
			//appendtograph/W=MDCpick //mdcy1, mdcy2
			//ModifyGraph/W=MDCpick rgb(mdcy1)=(65535,54611,49151)
			//ModifyGraph/W=MDCpick rgb(mdcy2)=(65535,54611,49151)
			//ReorderTraces mdcy,{mdcy1,mdcy2}
			ModifyGraph margin(top)=17
		ValDisplay valdisp0,pos={71,6},size={39,13},title="c"
		ValDisplay valdisp0,limits={0,0,0},barmisc={0,1000},value= #"showW_combM"
		ValDisplay valdisp1,pos={126,6},size={42,13},title="w"
		ValDisplay valdisp1,limits={0,0,0},barmisc={0,1000},value= #"showW_winnumM"
		endif	
	endif
	
	endif
	
	///////////////  Fit用にroot folderにもmdcyを作成
	duplicate/o mdcy root:mdcy
	/////////////////////////////////////////////
	
	
	SetDataFolder  root:

End


Function DO_ShwW_button_doneAll(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow/K WavesShow
	Dowindow TmpWave
	if (V_flag==1)
		Dowindow/K TmpWave
	endif		
	
	Dowindow EDCpick
	if (V_flag==1)
		Dowindow/K EDCpick
	endif
	
	Dowindow TmpWaveMDC
	if (V_flag==1)
		Dowindow/K TmpWaveMDC
	endif		
	
	Dowindow MDCpick
	if (V_flag==1)
		Dowindow/K MDCpick
	endif		
	
	
End


Function DO_ShwW_button_doneEDC(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow/K TmpWave
	Dowindow/K EDCpick
	
End

//in progress...
Function DO_ShwW_button_doneMDC(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow/K TmpWaveMDC
	Dowindow/K MDCpick
	
End

Macro DO_ShwW_Savewaves(Qedcmdc, Qreverse, wavehead, Qgraph, infoname)
variable Qedcmdc =  ShowW_Qedcmdc
Prompt Qedcmdc "EDC(tmp) or MDC(MDctmp) ?", popup, "EDC;MDC"
variable Qreverse =  ShowW_Qreverse
Prompt Qreverse "save waves in reverse order?", popup, "no;yes"
String wavehead = ShowW_wavehead
Prompt wavehead "head strings of saving waves", popup, "wave;enter by youself"
variable Qgraph = ShowW_Qgraph
Prompt Qgraph "record to graph table?", popup, "no;yes by auto;yes by specifying"
string infoname
Prompt infoname "string in info_wave ", popup, ShowW_MN  +";" + ShowW_GMN + ";enter by yourself"

	variable cond1
	cond1=cmpstr(wavehead, "enter by youself")
	if  (cond1==0)
		wavehead=Do_ShoW_askwavehead()
	endif
	
	variable cond2
	cond2=cmpstr(infoname, "enter by youself")
	print Qgraph, infoname, cond2
	if  (cond2==0&&Qgraph==2)
		infoname=Do_ShoW_askinfoname()
	endif

	

endmacro

Function/S Do_ShoW_askwavehead()

	DFREF dfr = root:DataLoadFolder
	string str1
	SVAR  sw_str1 = dfr:ShowW_str1
	str1 = sw_str1
	Prompt str1, "enter the head string of saving waves"
	Doprompt "wavehead", str1
	sw_str1 = str1
return str1
end

Function/S Do_ShoW_askinfoname()

	DFREF dfr = root:DataLoadFolder
	string str2
	SVAR  sw_str2 = dfr:ShowW_str2
	str2 = sw_str2
	Prompt str2, "enter the  string of info_wave"
	Doprompt "info", str2
	sw_str2 = str2
return str2
end



Function DO_ShwW_button_NormPanel(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:DataLoadFolder
	NVAR sw_Norm_flag = dfr:ShowW_Norm_flag
//	Variable/G ShowW_Norm_flag

	Dowindow  WS_Norm
	if (V_flag==0)
		Execute "WS_Norm()"
	endif
	Dowindow/F  WS_Norm
	sw_Norm_flag =1
	Button button5 fColor=(1,9611,39321), win=WavesShow
	DO_ShwW_DataNorm()
	
End

Window WS_Norm() 
	PauseUpdate; Silent 1		// building window...
	print "WS_Norm is called"
	DO_ShwW_SetNormPanel()
	NewPanel /W=(796,81,964,224)
	ModifyPanel cbRGB=(49151,65535,49151)
	CheckBox check0,pos={8,25},size={30,14},proc=DO_ShwW_check_NoiseRed,title="NR"
	CheckBox check0,variable= :DataLoadFolder:ShowW_flag_NR
	SetVariable setvar7,pos={44,25},size={54,12},proc=DO_ShwW_setvar_Norms,title="sp"
	SetVariable setvar7,font="Helvetica",value= :DataLoadFolder:ShowW_NR_sp
	SetVariable setvar5,pos={98,24},size={59,12},proc=DO_ShwW_setvar_Norms,title="ep"
	SetVariable setvar5,font="Helvetica",value= :DataLoadFolder:ShowW_NR_ep
	CheckBox check1,pos={8,56},size={37,14},proc=DO_ShwW_check_Combine,title="Cmb"
	CheckBox check1,font="Helvetica",variable= :DataLoadFolder:ShowW_flag_comb
	SetVariable setvar6,pos={45,57},size={53,12},proc=DO_ShwW_setvar_Norms,title="cx"
	SetVariable setvar6,font="Helvetica",value= :DataLoadFolder:ShowW_comb_x
	SetVariable setvar8,pos={100,57},size={56,12},proc=DO_ShwW_setvar_Norms,title="cy"
	SetVariable setvar8,font="Helvetica",value= :DataLoadFolder:ShowW_comb_y
	CheckBox check3,pos={8,76},size={35,14},proc=DO_ShwW_check_Normalize,title="Nrm"
	CheckBox check3,font="Helvetica",variable= :DataLoadFolder:ShowW_flag_Norm
	SetVariable setvar0,pos={49,77},size={50,12},proc=DO_ShwW_setvar_Norms,title="s"
	SetVariable setvar0,font="Helvetica",value= :DataLoadFolder:ShowW_Norm_sr
	SetVariable setvar11,pos={104,77},size={52,12},proc=DO_ShwW_setvar_Norms,title="e"
	SetVariable setvar11,font="Helvetica",value= :DataLoadFolder:ShowW_Norm_er
	SetVariable setvar9,pos={44,41},size={94,12},proc=DO_ShwW_setvar_Norms,title="condfactor"
	SetVariable setvar9,font="Helvetica"
	SetVariable setvar9,limits={-inf,inf,0.005},value= :DataLoadFolder:ShowW_condfactor
	Button button0,pos={19,119},size={35,16},proc=DO_ShwW_button_doneNormPanel,title="done"
	Button button0,font="Helvetica",fSize=10,fColor=(65535,0,0)
	Button button1,pos={67,119},size={35,16},proc=DO_ShwW_button_SaveNormMat,title="save"
	Button button1,font="Helvetica",fSize=10,fColor=(0,43690,65535)
	SetVariable setvar1,pos={23,5},size={76,15},title="oriM",value= :DataLoadFolder:ShowW_origMN
	CheckBox check4,pos={8,97},size={42,14},proc=DO_ShwW_check_MNormalize,title="MNrm"
	CheckBox check4,font="Helvetica",variable= :DataLoadFolder:ShowW_flag_MNorm
	SetVariable setvar2,pos={49,98},size={50,12},proc=DO_ShwW_setvar_Norms,title="s"
	SetVariable setvar2,font="Helvetica",value= :DataLoadFolder:ShowW_Norm_sr
	SetVariable setvar12,pos={104,98},size={52,12},proc=DO_ShwW_setvar_Norms,title="e"
	SetVariable setvar12,font="Helvetica",value= :DataLoadFolder:ShowW_Norm_er
EndMacro


Function DO_ShwW_SetNormPanel()

	DFREF dfr = root:DataLoadFolder

	//MatClacCondition
	NVAR NR_sp = dfr:ShowW_NR_sp 
	NVAR NR_ep = dfr:ShowW_NR_ep 
	NVAR comb_x = dfr:ShowW_comb_x 
	NVAR comb_y = dfr:ShowW_comb_y 
	NVAR Norm_sr = dfr:ShowW_Norm_sr 
	NVAR Norm_er = dfr:ShowW_Norm_er 
	NVAR MNorm_sr = dfr:ShowW_MNorm_sr 
	NVAR MNorm_er = dfr:ShowW_MNorm_er 
	NVAR condfactor = dfr:ShowW_condfactor

	NVAR inicheck = dfr:ShowW_WSnormWin_ini
	
	
	if (inicheck==0)
		NR_sp =0
		NR_ep = 100
		comb_x = 1
		comb_y = 1
		Norm_sr = 0
		Norm_er =100
		condfactor =1.1
		MNorm_sr =0
		MNorm_er =100
	
		inicheck=1		
	endif

end


Function DO_ShwW_check_NoiseRed(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:DataLoadFolder

	NVAR sw_flag_NR = dfr:ShowW_flag_NR
	sw_flag_NR =  checked	
	DO_ShwW_DataNorm()
	DO_ShwW_TmpwaveUpdate()

End

Function DO_ShwW_check_Combine(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:DataLoadFolder

	NVAR sw_flag_comb = dfr:ShowW_flag_comb
	sw_flag_comb = checked	
	DO_ShwW_DataNorm()
	DO_ShwW_TmpwaveUpdate()
	
End

Function DO_ShwW_check_Normalize(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:DataLoadFolder
	NVAR sw_flag_Norm = dfr:ShowW_flag_Norm
	sw_flag_Norm = checked	
	DO_ShwW_DataNorm()
	DO_ShwW_TmpwaveUpdate()

End


Function DO_ShwW_check_MNormalize(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:DataLoadFolder
	NVAR sw_flag_MNorm = dfr:ShowW_flag_MNorm
	sw_flag_MNorm = checked	
	DO_ShwW_DataNorm()
	DO_ShwW_TmpwaveUpdate()

End

Function DO_ShwW_DataNorm()

	DFREF dfr = root:DataLoadFolder
	SVAR  sw_origMN = dfr:ShowW_origMN
	wave m2 = dfr:storeM2
	wave sm2 = dfr:showM2


	NVAR ShowW_flag_NR = dfr:ShowW_flag_NR
	NVAR ShowW_NR_sp  = dfr:ShowW_NR_sp 
	NVAR ShowW_NR_ep = dfr:ShowW_NR_ep
	NVAR ShowW_flag_comb = dfr:ShowW_flag_comb
	NVAR ShowW_comb_x = dfr:ShowW_comb_x
	NVAR ShowW_comb_y = dfr:ShowW_comb_y
	NVAR ShowW_flag_Norm = dfr:ShowW_flag_Norm
	NVAR ShowW_Norm_sr = dfr:ShowW_Norm_sr
	NVAR ShowW_Norm_er = dfr:ShowW_Norm_er
	NVAR ShowW_condfactor = dfr:ShowW_condfactor
	NVAR ShowW_flag_MNorm = dfr:ShowW_flag_MNorm
	NVAR ShowW_MNorm_sr = dfr:ShowW_MNorm_sr 
	NVAR ShowW_MNorm_er = dfr:ShowW_MNorm_er 
	
	//wave redxymat

//	if (ShowW_MList_flag==1)
//		showmatN = ShowW_MN
//	elseif(ShowW_MList_flag==2)
//		showmatN = ShowW_GMN
//	endif
	
//	duplicate/o $showmatN storeM2

	
	
	if (cmpstr(sw_origMN ,"")==0)
		return -1
	endif
	
	duplicate/o $sw_origMN m2
	String Stornote
	Stornote = note(m2)
	redimension/D m2


		if(ShowW_flag_NR==1)
			DO_DtShw_BGnoiseRemove(m2, ShowW_NR_sp, ShowW_NR_ep, ShowW_condfactor)
			Note m2, Stornote
		endif
		
		if(ShowW_flag_Norm==1)
			if (ShowW_Norm_sr <= ShowW_Norm_er )
				DO_DtShw_NormMat(m2, ShowW_Norm_sr ,ShowW_Norm_er)
			else
				print "start point has to be smaller than end point"
				return -1
			endif
			
		endif
		
		if(ShowW_flag_MNorm==1)
			if (ShowW_MNorm_sr <= ShowW_MNorm_er )
			  DO_DtShw_MNormMat(m2, ShowW_Norm_sr ,ShowW_Norm_er)
			else
				print "start point has to be smaller than end point"
				return -1
			endif

		endif	
		
		if(ShowW_flag_comb==1)
			if (ShowW_comb_x>=1 && ShowW_comb_y>=1)
			  DO_DtShw_CombMat(m2, ShowW_comb_x, ShowW_comb_y)
			endif 
			Note m2, Stornote
		endif
		
	
	duplicate/o m2 sm2


End


Function DO_ShwW_setvar_Norms(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_ShwW_DataNorm()
	DO_ShwW_TmpwaveUpdate()
End


Function DO_ShwW_button_doneNormPanel(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:DataLoadFolder
	NVAR sw_Norm_flag = dfr:ShowW_Norm_flag

	//Variable/G ShowW_Norm_flag
	Dowindow/K WS_Norm
	Button button5 fColor=(48059,48059,48059), win=WavesShow	
	sw_Norm_flag =0
	
	SVAR sw_origMN = dfr:ShowW_origMN
	//String/G  	ShowW_origMN
	wave sm2 = dfr:showM2
	//wave showM2
	duplicate/o $sw_origMN sm2
	DO_ShwW_TmpwaveUpdate()

End

Function DO_ShwW_Popup_MList(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Variable/G ShowW_MList_flag

	ShowW_MList_flag = popNum

End


Function DO_ShwW_button_SaveNormMat(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:DataLoadFolder

	wave sm2 = dfr:showM2
	//wave showM2
	string matname
	string message
	SVAR sw_GMN = dfr:ShowW_GMN
	//string/G ShowW_GMN
	SVAR sw_MN  = dfr:ShowW_MN 
	//string/G ShowW_MN
	NVAR MList_flag = dfr:ShowW_MList_flag
	//Variable/G ShowW_MList_flag

	if (MList_flag==1)
		matname = sw_MN + "_nm"
	elseif(MList_flag==2)
		matname = sw_GMN + "_nm"
	endif
	
	message = "Enter the new matrix name"
	Prompt matname, message
	Doprompt "Matsave", matname
	
	if (exists(matname)==1)
		variable yesno
		Prompt yesno, "Do you surely overwite the matrix of ["+matname + "] ?", popup, "yes;no"
		DoPrompt "Overwite", yesno
		
			if (V_Flag)
			return -1
			endif
		
		if (yesno==1)
			duplicate/o sm2, $matname
		elseif (yesno==2)
			return 0
		endif

	elseif(exists(matname)==0)
	
		duplicate sm2, $matname
	
	endif
	
		////////////////////////  Add to Info_Wave //////////////////////////////////
	Variable CaseOfInfo
	
	message= "Do you want to add the loaded matrix name into \"Info_wave\"?" 
	Prompt CaseOfInfo, message, popup, "No; Yes, add automatically; Yes, add by myself"
	Doprompt "DataLoad", CaseOfInfo
	if (V_Flag)
	return -1
	endif
	
	String WList, Wname
	WList = "X_base;Last_Wave;Offset_Wave;Bias_Wave;Angle;Info_Wave;Y_base;X_start_Wave;Start_Wave;memo;"
	
	Variable ii=0
		Do
			Wname = Stringfromlist(ii,WList)
			if (waveexists($WName)==0)
				Abort "You did not make graph tables and waves like \"Info_wave\" and so on!!"
				return -1
			endif
			ii+=1
		while (ii<10)
	
	wave/T Info_wave
	variable ii2
	
	if (CaseOfInfo==1)
		return -1
	endif
	
	if (CaseOfInfo==2)
		String TextWList = "Info_Wave;memo;"
		String NumericWList =  "Last_Wave;Offset_Wave;Bias_Wave;X_start_Wave;Start_Wave"
		Variable maxlastcell=-1, cell1
		
		ii=0
		Do 
			WName = Stringfromlist(ii,TextWList)
			cell1=	 DO_DtShw_LastOccupiedCell_TXT($Wname)
			if (maxlastcell<=cell1)
				maxlastcell = cell1
			endif
			ii+=1
		while (ii<2)
		
		ii=0
		Do 
			WName = Stringfromlist(ii,NumericWList)
			cell1=	 DO_DtShw_LastOccupiedCell($Wname)
			if (maxlastcell<=cell1)
				maxlastcell = cell1
			endif
			ii+=1
		while (ii<5)
		print maxlastcell
		DO_DtShw_RestLengthCheck(0,0, maxlastcell)  /// Graphtable内のwaveサイズが足りなければ増加
		
		ii2 = maxlastcell+1
		Info_wave [ii2] = matname	
		
		 DO_GraT_ResizeGraphTable()	
	endif
	
	if (CaseOfInfo==3)
		message = "please enter the first cell number of Info_wave to dataload"
		Prompt maxlastcell, message
		Doprompt "Enter Number", maxlastcell
		
		Info_wave [maxlastcell] = matname
		 DO_GraT_ResizeGraphTable()
		
	endif
	
	

	
End


// in progress......
Function DO_ShwW_button_SaveEDCs(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow  TmpWave
	if (V_flag==0)
		return -1	
	endif
	Dowindow/F TmpWave
	
	Variable CaseOfInfo
	String message
	message= "Please choose where and how to save tmpwaves" 
	Prompt CaseOfInfo, message, popup, "To the same column of graphtable; To the specific column of graphtable; just to datafolder"
	Doprompt "wavesave", CaseOfInfo
	if (V_Flag)
	return -1
	endif
	
	
//	if (CaseOfInfo==1)
//		String/G ShowW_GMN
//
//		ShowW_GMN = Info_Wave[ShowW_Gmatnum]
//	ShowW_ang = Angle[ShowW_Gmatnum]
//	wave showM2
//	if (waveexists($ShowW_GMN )==1)
//	duplicate/o $ShowW_GMN showM2 
//	endif


	//endif
	
	
	
End



Function DO_ShwW_thetacalcEDC()
DFREF dfr = root:DataLoadFolder
NVAR  sw_comb = dfr:ShowW_comb
NVAR  sw_winnum = dfr:ShowW_winnum
wave sm2 = dfr:showM2

//Variable/G  ShowW_comb
//Variable/G  ShowW_winnum

	Variable theta_ini, theta_step
	Variable theta
	
	theta_ini =  dimoffset(sm2,1)
	theta_step =  dimdelta(sm2,1)

	Variable w0, theta0
	
	w0 = sw_comb * sw_winnum
	theta0 = 	theta_ini  + w0 * theta_step 
	
//	print w0,theta0
	
	theta =  theta0 + theta_step *(sw_comb -1)/2

//	print ShowW_winnum,theta	
	
	return theta
End


Function DO_ShwW_thetacalcMDC()
DFREF dfr = root:DataLoadFolder
NVAR  sw_combM = dfr:ShowW_combM
NVAR  sw_winnumM = dfr:ShowW_winnumM
wave sm2 = dfr:showM2

//Variable/G  ShowW_combM
//Variable/G  ShowW_winnumM

	Variable theta_ini, theta_step
	Variable theta
	
	theta_ini =  dimoffset(sm2,0)
	theta_step =  dimdelta(sm2,0)

	Variable w0, theta0
	
	w0 = sw_combM * sw_winnumM
	theta0 = 	theta_ini  + w0 * theta_step 	
	theta =  theta0 + theta_step *(sw_combM -1)/2	
	return theta
End

Function DO_ShwW_EnergyCalcMDC()
DFREF dfr = root:DataLoadFolder
NVAR  sw_combM = dfr:ShowW_combM
NVAR  sw_winnumM = dfr:ShowW_winnumM
wave sm2 = dfr:showM2

//Variable/G  ShowW_combM
//Variable/G  ShowW_winnumM

	Variable ene_ini, ene_step
	Variable energy
	
	ene_ini =  dimoffset(sm2,0)
	ene_step =  dimdelta(sm2,0)

	Variable w0, energy0
	
	w0 = sw_combM * sw_winnumM
	 energy0 = ene_ini  + w0 * ene_step 	
	energy =   energy0 + ene_step *(sw_combM -1)/2	
	return energy
End



// in progres ....
Function DO_ShowW_SetFitPaneA()

	String/G  Fit_SaveTableName
	Variable/G  Fit_Cellnum
	Variable/G  Fit_energy
	Variable/G  Fit_theta
	Variable/G  Fit_EDCMDC
	
end

// in progres ....
Macro DO_ShwW_SaveFittingResults(ctrlName) : ButtonControl
	String ctrlName
	
	Variable theta
	String/G  Fit_SaveTableName
	Variable/G  Fit_Cellnum
	Variable/G  Fit_EDCMDC

	String WNx,WN1,WN2,WN3,WN4
	
	WNx =  Fit_SaveTableName+"_x"
	WN1 =  Fit_SaveTableName+"_1"
	WN2=  Fit_SaveTableName+"_2"
	WN3 =  Fit_SaveTableName+"_3"
	WN4 =  Fit_SaveTableName+"_4"
	
	Variable cellnum 
//	cellnum = LastOccupiedCell($WNx) +1
	cellnum = Fit_Cellnum
	
	if ( Fit_EDCMDC==0)
		theta = DO_ShwW thetacalcEDC()
	endif
	if  ( Fit_EDCMDC==1)
		theta = DO_ShwW_thetacalcMDC()
	endif
	
	$WNx[cellnum] = theta
	$WN1[cellnum] = WGFitK[2]
	$WN2[cellnum] = WGFitK[6]
	$WN3[cellnum] = WGFitK[10]
	$WN4[cellnum] = WGFitK[14]


End

// in progres ....
Window DO_FitPanelA()
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(854,61,1043,208)
	SetDrawLayer UserBack
	DrawText 22,25,"EDC"
	DrawText 22,42,"MDC"
	SetVariable setvar6,pos={98.00,12.00},size={47.00,13.00},proc=DO_ShwW_setvar_EDCselect_Fit,title="w"
	SetVariable setvar6,font="Helvetica",limits={0,1000,1},value= ShowW_winnum
	SetVariable setvar2,pos={56.00,12.00},size={40.00,13.00},proc=DO_ShwW_setvar_EDCcom,title="c"
	SetVariable setvar2,font="Helvetica",limits={0,1000,1},value= ShowW_comb
	Button Fit,pos={23.00,51.00},size={58.00,30.00},proc=ButtonProc_Fit5,title="Fit"
	Button Fit,fSize=16,fColor=(49163,65535,32768)
	SetVariable setvar1,pos={92.00,56.00},size={44.00,16.00},title=" "
	SetVariable setvar1,font="Helvetica",fSize=12,value= Fit_SaveTableName
	Button Fit1,pos={23.00,82.00},size={58.00,30.00},proc=DO_ShwW_SaveFittingResults,title="Save"
	Button Fit1,fSize=16,fColor=(49163,65535,32768)
	SetVariable setvar0,pos={93.00,77.00},size={44.00,14.00},title=" "
	SetVariable setvar0,value= Fit_Cellnum
	SetVariable setvar8,pos={57.00,31.00},size={40.00,13.00},proc=DO_ShwW_setvar_MDCcom,title="c"
	SetVariable setvar8,font="Helvetica",value= ShowW_combM
	SetVariable setvar10,pos={100.00,31.00},size={47.00,13.00},proc=DO_ShwW_setvar_MDCselect_Fit,title="w"
	SetVariable setvar10,font="Helvetica",value= ShowW_winnumM
	CheckBox check0,pos={96.00,94.00},size={53.00,16.00},title="E/0 M/1"
	CheckBox check0,variable= Fit_EDCMDC
EndMacro


// in progres ....
Function DO_ShwW_setvar_EDCselect_Fit(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_ShwW_EDCcloseUP(varNum)
	Variable/G  Fit_theta
	Variable theta
	theta = DO_ShwW_thetacalcEDC()
	Fit_theta =theta
	
End


// in progress..
Function DO_ShwW_setvar_MDCselect_Fit(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	Do_ShwW_MDCcloseUP(varNum)
	Variable/G  Fit_energy
	Variable/G  Fit_theta
	Variable energy
	Variable theta
	energy = DO_ShwW_EnergyCalcMDC()
	theta = DO_ShwW_thetacalcMDC()
	Fit_energy = energy
	Fit_theta =theta
	
End

Function DO_ShwW_setvar_DataName_GraT(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:DataLoadFolder
	NVAR sw_Gmatnum = dfr:ShowW_Gmatnum
	SVAR sw_GMN = dfr:ShowW_GMN
	NVAR sw_ang = dfr:ShowW_ang
//	Variable/G ShowW_Gmatnum
//	String/G ShowW_GMN
//	Variable/G ShowW_ang
	SVAR sw_StoreMN = dfr:ShowW_StoreMN
	SVAR sw_origMN = dfr:ShowW_origMN
	
	if (waveexists(Info_Wave)==0)
		print "Activate graphtable in DataOpen Panel"
		return -1
	endif
	
	if (waveexists(Angle)==0)
		print "Activate graphtable in DataOpen Panel"
		return -1
	endif
	
	wave/T Info_Wave
	wave Angle
	
//	String/G ShowW_StoreMN 
//	String/G  ShowW_origMN

	sw_GMN = Info_Wave[sw_Gmatnum]
	sw_ang = Angle[sw_Gmatnum]
	
	wave sm2 = dfr:showM2
//	wave showM2
	if (waveexists($sw_GMN)==1)
	duplicate/o $sw_GMN sm2
	sw_StoreMN  = sw_GMN 
	endif
	
	sw_origMN =  sw_GMN 
	
	NVAR sw_Norm_flag = dfr:ShowW_Norm_flag
	//Variable/G ShowW_Norm_flag
	if (sw_Norm_flag==1)
		DO_ShwW_DataNorm()
	endif
		
	DO_ShwW_TmpwaveUpdate()
	
	
End


Function DO_ShwW_button_ShowMatNewWin(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:DataLoadFolder
	SVAR sw_StoreMN = dfr:ShowW_StoreMN

	String/G ShowW_StoreMN 
	if (cmpstr(sw_StoreMN ,"")==1)
		Display;AppendImage $sw_StoreMN
		ModifyImage $sw_StoreMN ctab= {*,*,Terrain,0}
		ModifyGraph swapXY=1
	endif
	
End



Function DO_ShwW_button_ImageProf(ctrlName) : ButtonControl
	String ctrlName

	WMCreateImageLineProfileGraph();

End

Function DO_ShwW_setvar_setN_global(ctrlName,varNum,varStr,varName) : SetVariableControl 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DO_ShwW_MatrixListIndex()
	
	DFREF dfr = root:DataLoadFolder
	wave/T mnl = dfr:ShowW_MNList
	String MatName1
	MatName1 = mnl[varNum]
	SVAR sw_MN  = dfr:ShowW_MN 
	//String/G ShowW_MN
	sw_MN = MatName1
//	String/G ShowW_StoreMN 
	SVAR sw_StoreMN = dfr:ShowW_StoreMN
	sw_StoreMN  = MatName1
	SVAR sw_origMN = dfr:ShowW_origMN
	//String/G  ShowW_origMN
	sw_origMN = sw_StoreMN

	
	DO_ShwW_DataUPdate()
	
	//Variable/G ShowW_Norm_flag
	NVAR sw_Norm_flag = dfr:ShowW_Norm_flag
	if (sw_Norm_flag==1)
	DO_ShwW_DataNorm()
	endif

	DO_ShwW_TmpwaveUpdate()
	
	
End

Function DO_ShwW_setvar_DataName_global(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:DataLoadFolder
	SVAR sw_origMN = dfr:ShowW_origMN
	
	//String/G  ShowW_origMN
	sw_origMN = ctrlName
	
	DO_ShwW_DataUPdate()
	
		
	//Variable/G ShowW_Norm_flag
	NVAR sw_Norm_flag = dfr:ShowW_Norm_flag

	if (sw_Norm_flag==1)
	DO_ShwW_DataNorm()
	endif
	
	DO_ShwW_TmpwaveUpdate()
	
End



Function DO_ShwW_TmpwaveUpdate()

	DFREF dfr = root:DataLoadFolder

	Dowindow  TmpWave
	if (V_flag==1)
		Do_ShoW_ClearAllwaves("TmpWave")
		DO_ShwW_TmpEDCUpdate("TmpWave")
	endif

	NVAR numE = dfr:ShowW_winnum
	Dowindow  EDCpick
	if (V_flag==1)
		DO_ShwW_EDCcloseUP(numE)
	endif
	
	Dowindow  TmpWaveMDC
	if (V_flag==1)
		Do_ShoW_ClearAllwaves("TmpWaveMDC")
		DO_ShwW_TmpMDCUpdate("TmpWaveMDC")
	endif

	
	NVAR numM = dfr:ShowW_winnumM
	Dowindow  MDCpick
	if (V_flag==1)
		Do_ShwW_MDCcloseUP(numM)
	endif
	
End


Macro DO_ShowW_Auto_Labelmaker(Hori,Verti,HoriAxis,VertiAxis)
Variable Hori=1,Verti=1,HoriAxis=1,VertiAxis=2
Prompt  Hori,"x axis name", Popup, "Binding Energy (meV); Binding Energy (eV); Kinetic Energy (eV); Angle; Momentum; Wavevector"
Prompt Verti, "y axis name", Popup, "Intensity (arb. units); Binding Energy (meV); Binding Energy (eV); Kinetic Energy (eV); Angle; Momentum; Wavevector"
Prompt HoriAxis,"x axis label?", Popup, "ON; OFF"
Prompt VertiAxis, "y axis label?", Popup, "ON; OFF"

ModifyGraph mirror=2

if (Hori==1)															//ラベルbottomの表示選択
Label bottom "\\F'Times'\\Z18Binding Energy (meV)"
Endif

if (Hori==2)
Label bottom "\\F'Times'\\Z18Binding Energy (eV)"
Endif

if (Hori==3)
Label bottom "\\F'Times'\\Z18Kinetic Energy (eV)"
Endif

if (Hori==4)
Label bottom "\\F'Times'\\Z18Angle"
Endif

if (Hori==5)
Label bottom "\\F'Times'\\Z18Momentum"
Endif

if (Hori==6)
Label bottom "\\F'Times'\\Z18Wavevector"
Endif

if (Verti==1)													//ラベルleftの表示選択
Label left "\\F'Times'\\Z18Intensity (arb. units)"
Endif

if (Verti==2)
Label left "\\F'Times'\\Z18Binding Energy (meV)"
Endif

if (Verti==3)
Label left "\\F'Times'\\Z18Binding Energy (eV)"
Endif

if (Verti==4)
Label left "\\F'Times'\\Z18Kinetic Energy (eV)"
Endif

if (Verti==5)
Label left "\\F'Times'\\Z18Angle"
Endif

if (Verti==6)
Label left "\\F'Times'\\Z18Momentum"
Endif

if (Verti==7)
Label left "\\F'Times'\\Z18Wave Vector"
Endif


if (VertiAxis==1)						//ラベルleftのthickの設定
ModifyGraph tick(left)=0
ModifyGraph noLabel(left)=0
Endif

if (VertiAxis==2)
ModifyGraph noLabel(left)=1
ModifyGraph tick(left)=3
Endif

if (HoriAxis==1)							//ラベルbottomのthickの設定
ModifyGraph tick(bottom)=0
ModifyGraph noLabel(bottom)=0
Endif

if (HoriAxis==2)
ModifyGraph noLabel(bottom)=1
ModifyGraph tick(bottom)=3
Endif


EndMacro



// in progress...
Function DO_ShwW_SaveEDC()

	Dowindow  TmpWave
	if (V_flag==0)
		return -1
	endif

	String wavehead="wave", xwavehead ="xwave"
	Variable stratnum
	String yseno ="no"
	String yseno3="yes"
	
	Prompt wavehead, "Enter a wavehead " 
	Prompt stratnum, "Enter a start number for savinf wave"
	Prompt yseno,"Do you need xwave?", popup "yes;no" 
	DoPrompt "Wavehead", wavehead, stratnum, yseno
	if (V_Flag)
		return -1	// User canceled
 	endif

	xwavehead="x"+wavehead
	if (cmpstr(yseno,"yes")==0)
		Prompt xwavehead, "Enter a wavehead for xwave"
		DoPrompt "Wavehead for xwave", xwavehead
		if (V_Flag)
			return -1	// User canceled
 		endif
	endif
	
	
	String windowname = "TmpWave"	
	String WList
	String Wname
	String SaveWname
	String yesno2
	Variable exsitflag=0
	variable ii, endnum
	DFREF dfr = root:DataOpenF

	WList =Tracenamelist(windowname, ";",1)
	ii=0
	Do
		Wname = stringfromlist(ii,WList)
		SaveWname = wavehead + num2str(ii+stratnum)
		if (WaveExists($SaveWname)!=0)
		exsitflag =1
		endif
	ii+=1
		Wname = stringfromlist(ii,WList)
	while(cmpstr(Wname,"")!=0)

	if (exsitflag==1)
		Prompt yesno2, "Ohter wave has same name. Do you want overwrite?", popup "yes;no" 
		DoPrompt "case of overwrite", yesno2
		if (cmpstr(yesno2,"no")==0)
			return -1	// User canceled
 		endif
	endif
 
 
	ii=0
	Do
		Wname = stringfromlist(ii,WList)
		SaveWname = wavehead + num2str(ii+stratnum)
		duplicate/o dfr:$Wname $SaveWname
		ii+=1
		Wname = stringfromlist(ii,WList)
		endnum = ii-1
	while(cmpstr(Wname,"")!=0)
	
	print wavehead+ num2str(stratnum) , "to", wavehead+ num2str(endnum) , "have been saved"

 	Prompt yseno3,"Do you want to show saved waves?", popup "yes;no" 
 	Doprompt "Show waves", yseno3
 	Variable/G showW_offset
 	variable offset
 	
 	if (cmpstr(yesno2,"yes")==0)
		display
		ii=0
		Do
			SaveWname = wavehead + num2str(ii+stratnum)
			appendtograph $SaveWname
			offset = ii *  ShowW_offset
			ModifyGraph offset($SaveWname)={0,offset}
			ii+=1
		while(ii<(endnum+1))
 	endif
	 
End



