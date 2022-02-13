#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.


//  Script to load ChunkCubeData of deflector mapping mode in DA30 
//  written in Igor 8.04 (64 bit)
//
//  Seigo Soiuma,    Tohoku University  
//		June, 23, 2021
//
//  [steps of use]
// 1) expand the zip file stored by deflector mapping
// 2) run tht function of ChunkCubeLoader() in command line in igor
// 3) select the "viewer.ini" in the exanded folder


function ChunkCubeLoader()

	string textLine
	string workingDirectory = ""
	variable refNum
	Open/D/R/T=".ini" refNum
	textLine = S_fileName
	variable ii,jj
	variable closeFile = 1


	if (refNum <= 0)
	jj = strlen(textLine)-strlen(":viewer.ini")
		ii = 0
		do
			workingDirectory[ii] = textLine[ii]
			ii = ii+1
		while(ii<jj)
		
			NewPath /O/Q DA30_WD workingDirectory;
	
		open /R /Z=1 /P=DA30_WD refNum as "viewer.ini"
		FStatus refNum
		if (!V_Flag)
			abort "File error. Could not open viewer.ini"
		endif
			else
		closeFile = 0
	endif // if (refNum <= 0)	
	
	make/o/N=3 dimInfo, offsetInfo,deltaInfo  // for load to wave scaling info

	
	make/o/N=0/T outputTextWave  // string to use grep 

	// wave scaling is written in "viewer.ini"
	// gerp operation take a text line which macthes a regular expression 
	Grep/P=DA30_WD/E="(?i)width=" "viewer.ini" outputTextWave
	dimInfo[0] = numberbykey("width",outputTextWave[0],"=")
	Grep/P=DA30_WD/E="(?i)height=" "viewer.ini" outputTextWave
	dimInfo[1] = numberbykey("height",outputTextWave[0],"=")
	Grep/P=DA30_WD/E="(?i)depth=" "viewer.ini" outputTextWave
	dimInfo[2] = numberbykey("depth",outputTextWave[0],"=")
	
	Grep/P=DA30_WD/E="(?i)offset=" "viewer.ini" outputTextWave
	offsetInfo[0] = numberbykey("width_offset",outputTextWave[0],"=")
	offsetInfo[1] = numberbykey("height_offset",outputTextWave[1],"=")
	offsetInfo[2] = numberbykey("depth_offset",outputTextWave[2],"=")

	Grep/P=DA30_WD/E="(?i)delta=" "viewer.ini" outputTextWave
	deltaInfo[0] = numberbykey("width_delta",outputTextWave[0],"=")
	deltaInfo[1] = numberbykey("height_delta",outputTextWave[1],"=")
	deltaInfo[2] = numberbykey("depth_delta",outputTextWave[2],"=")

	
	// get binary file of deflector mapping
	String filename
	Grep/P=DA30_WD/E="(?i)path=" "viewer.ini" outputTextWave
	filename = Stringbykey("path",outputTextWave[1],"=" )
	
	
	make /O/ N=(dimInfo[0], dimInfo[1], dimInfo[2]) intensity_cube // 3D waves to load
	make /O /N=(dimInfo[0], dimInfo[1]) currentPlane // buffer matrix
	
	open /R /P=DA30_WD refNum as filename
	
	variable kk=0
	for (kk=0;kk<dimInfo[2];kk+=1)
		fBinRead refNum, currentPlane // load one plane
		intensity_cube[][][kk] = currentPlane[p][q]
	endfor
	
	SetScale/P x offsetInfo[0],deltaInfo[0],"eV", intensity_cube
	SetScale/P y offsetInfo[1],deltaInfo[1],"deg", intensity_cube
	SetScale/P z offsetInfo[2],deltaInfo[2],"deg", intensity_cube
	
	
	//reading header
	string header, headerfilename
	Grep/P=DA30_WD/E="(?i)ini_path" "viewer.ini" outputTextWave
	headerfilename = Stringbykey("ini_path",outputTextWave[0],"=" )
	
	Open/R/p=DA30_WD refNum  as headerfilename
	FReadLine/T="" refNum, header
	Note/K intensity_cube, header

	

	close refnum
	
	String wavename3d
	String CubeNameSuffix="_"
	Prompt CubeNameSuffix, "Enter extension word for 3d wave name (wavename becomes Matrix3DNamexxxx)"
	Doprompt "name of 3d cube", CubeNameSuffix
	
	wavename3d = "Matrix3Dname"+CubeNameSuffix
	
	if (V_flag==0)
		duplicate intensity_cube, $wavename3d
		killwaves intensity_cube
	endif
	
	killwaves outputTextWave,dimInfo, offsetInfo,deltaInfo
	killwaves currentPlane

end


