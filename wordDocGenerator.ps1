<#                             
Author of wordDocGenerator script @cyberw01f
Last updated 11/05/2018

.SYNOPSIS 
This file is for testing purposes only. 
Malicious use of this script is forbidden!!

.DESCRIPTION
Script generates a Microsoft Word document containing a macro. The macro vba code can be customzed. 

.Notes
############################################################
Macro enabled Wod Document generater requiers Microsoft Word 
Currently this script relies on Word already installed on the system the script will be ran on.
############################################################
I developed this script to assist testing security controls ability to detect/alert on Word documents containing macros. 
#>

#nl var simply does a carrage return / new line
$nl = [Environment]::NewLine

$logo = @"
	=================================================================
						_                         ___  _  __ 
			 ___ _   _| |__   ___ _ ____      __/ _ \/ |/ _|
			/ __| | | | '_ \ / _ \ '__\ \ /\ / / | | | | |_ 
		   | (__| |_| | |_) |  __/ |   \ V  V /| |_| | |  _|
			\___|\__, |_.__/ \___|_|    \_/\_/  \___/|_|_|  
				|___/                                      
		
	==================================================================
		 ,%#((%                                             %%%%%.                  
		%(%%,#%((%                                       %%%%%,&%%%               
		&(#(    /(&%%                                   &%%&*    #%%&              
		%%%*       .&%%#                               %%%&        #&%%                 
		,%%%          ,&%%                             %%%,          &%%               
		%%%             %%%,                         ,%%%             %%%                          
		%%%              %%%*                       *%%%              &%%                            
		,%%,         /%%#  %%%                       %%&  #%%/         ,%%,                           
		#%%           &%%.  %#%&&%%%%%%%%%%%%%%%&%%&%%%  /%%%           %%(                           
		(%%            %%%  .%%%&%*.       .*#&%&%%%.  %%%            %%(;)                              
		,%%*            %%%  %%%                   %&&  %%%            *%%                               
		%%%            %&%                             &%&            &%%                                  
	       &%%                                                           %%&                                    
	       *%%%                                                         %%%                                      
		%%%                                                         %%%                                       
		 &%%                                                       &%%                                         
		 .%%%                                                     %%%.                                          
		  ,%%%                                                   %%%.                                            
		   %%%                                                   %%%                                            
		 .%%%                                                  %%%.                                            
		,&%%      .%%%%%%%%%%%#            *&(%%(%(%%%&.      %%%,                                            
		%%%       %%%%%%%%%%%%%&/         /((&(&(%((%%%%%       %%%                                            
	       %%%              &%%&%%%%%&       &%&((((((&              %%%                                            
	      %(&.                &%%%,%%%       %%%,%%%%                 %%%                                           
	     %#(                   %%%           %%%                      %%%                                           
	    #%%                    %%%           %%%                       &%&                                         
	   &%%                     %%%           %%%                       %%%                                         
	   %%(                     %%%           &%%                       %%%                                         
	  ,%%,                     %%&           %%%                       (%%,                                        
	   %%%%                                                             %%%%                                         
	    &%%.                                                         .%%%                                           
	     %%%%               %%%    #%%%%%%%%%#    %%%               %%%%                                            
	     ,%%%              %#%/  %%&/.....(%%%  /%%%              &%%,                                             
	       &%%              %%%   %%%     %%%   %%&              %%%                                               
		&%%              &%%  ,%%&,,,%&%,  %%%              %%%                                                
		 %%%  ,&,         %%%  .&%%%&%&.  &%%         ,&,  &%%                                                     
		 .%%%%%%%%        ,%%%           %%%,        (%%%%%%%.                                                 
		  *(*  .%%%        /%%%%%%%%%%%%%%&.        (%%.  /&(                                                     
			%%%             #&&&&&&&&          %%%                                                           
			  %%%                             %%%                                                           
			   &%%                           %#%                                                             
			   %%%(  (%%               #((  /%%/ 
                             %%&%%%%%&             %%%%%%%%%                                                           												%%&%%%%%&             %%%%%%%%%                                                             
			      *%%(   %%         %%%%   (%%*                                                            
				     #%%%       &%%#                                                                   
				      %%&     %%%                                                                     					   %%%   %%%                                                                     
				        %%% %%%                                                                     
				         %%%%%                                                                     
				         #%%%#                                                                    						  %%&                                                                    
				           . 
				      @cyberw01f
"@

$label = @"  
                  Macro Enabled Word Document Generator
  Documents generated by this script are to be used only for testing security controls
                     Responsible use only permited
"@

function Get-RandomAlphaNum($len)
{
	$r = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	$tmp = foreach ($i in 1..[int]$len) {$r[(Get-Random -Minimum 1 -Maximum $r.Length)]}
	return [string]::Join('', $tmp)
}



function Create-WordDoc(){
###############################################################################
# Place your custom macro vba code between the code=@" and "@ lines.
###############################################################################
$code = @"
'PowerShell encoded command macro.
'Gets ip default gateway addr and Pings it 5 times. Ping results are displayed in a message box.
Private Sub Document_Open()
    strCommand = "Powershell -noprofile -windowstyle hidden -e JABnAGEAdABlACAAPQAgACgARwBlAHQALQB3AG0AaQBPAGIAagBlAGMAdAAgAFcAaQBuADMAMgBfAG4AZQB0AHcAbwByAGsAQQBkAGEAcAB0AGUAcgBDAG8AbgBmAGkAZwB1AHIAYQB0AGkAbwBuACAAfAAgAD8AewAkAF8ALgBJAFAARQBuAGEAYgBsAGUAZAB9ACkALgBEAGUAZgBhAHUAbAB0AEkAUABHAGEAdABlAHcAYQB5AA0ACgBwAGkAbgBnACAALQBuACAANQAgACQAZwBhAHQAZQA=" 
    Set WshShell = CreateObject("WScript.Shell")
    Set WshShellExec = WshShell.Exec(strCommand)
    strOutput = WshShellExec.StdOut.ReadAll
    MsgBox strOutput
End Sub
"@
$date = Get-Date -format MM-dd-yyyy
$time = Get-Date -Format HH:mm:ss:ms
[ref]$SaveFormat = "microsoft.office.interop.word.WdSaveFormat" -as [type]
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Vbe.Interop") | Out-Null
#$docName = Read-Host "Enter a name for the document but do not include file extension"
$docName = Get-RandomAlphaNum 5
$word = New-Object -ComObject word.application
$word.visible = $false
New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$($word.Version)\word\Security" -Name AccessVBOM -Value 1 -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$($word.Version)\word\Security" -Name VBAWarnings -Value 1 -Force | Out-Null
$doc = $word.documents.add()
$selection = $word.selection
$selection.WholeStory
$selection.Style = "No Spacing"
$selection.font.size = 14
$selection.font.bold = 1
$selection.typeText("My Document: Title")
$selection.TypeParagraph()
$selection.font.size = 11
$selection.typeText("Date: $date`n")
$selection.typeText("Time: $time`n")
$Selection.TypeParagraph()
$selection.font.size = 12
$selection.font.bold = 1
$selection.typeText("Created using Powershell Macro enabled Word generator`n")
$selection.TypeParagraph()
$selection.font.size = 11
$selection.font.bold = 0
#####################################################################################
# If you prefer random characters instead of Lorem Ipsum text uncomment this #$data 
# and place a # next to {xml}$tmpdata
#####################################################################################
#$data = Get-RandomAlphaNum 1000
[xml]$tmpdata = (new-object net.webclient).DownloadString("http://www.lipsum.com/feed/xml?amount=10&what=paras&start=yes&quot;")
$data = $tmpdata.feed.lipsum
$selection.TypeParagraph()
$selection.font.size = 11
$selection.typeText("Below is a randomly generated string of alphanumeric text. The string is autogenerated during document creation to ensure the file is a unique hash`n")
$selection.TypeParagraph()
$selection.font.size = 11
$selection.typeText("$data.feed.lipsum`n")
$docmodule = $doc.VBProject.VBComponents.item(1)
$docmodule.CodeModule.AddFromString($code)
$doc.SaveAs("$($ENV:UserProfile)\Desktop\$docName", [microsoft.office.interop.word.WdSaveFormat]::wdFormatDocument97)
$word.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | out-null
if (ps winword){kill -name winword}
#####################################################################################
# Document will be saved to the curent users desktop
#####################################################################################
$file = ("$($ENV:UserProfile)\Desktop\$docName.*")
$md5sum = Get-FileHash $file -Algorithm MD5 #| Format-List
$sha1 = Get-FileHash $file -Algorithm SHA1 #| Format-List
$sha256 = Get-FileHash $file -Algorithm SHA256 #| Format-List        
$md5sum
$sha1
$sha256
}
Write-Host -f Magenta $logo
Write-Host
Write-Host -f Green $label
Create-WordDoc
