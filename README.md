C:\Temp\$0ft\123\1
C:\Temp\$0ft\123\2
C:\Temp\$0ft\123\3
C:\Temp\$0ft\123\4
C:\Temp\$0ft\123\5
C:\Temp\$0ft\123\6
C:\Temp\$0ft\123\7
C:\Temp\$0ft\123\8
C:\Temp\$0ft\123\9
C:\Temp\$0ft\123\10
C:\Temp\$0ft\123\11
C:\Temp\$0ft\123\12
C:\Temp\$0ft\123\13
C:\Temp\$0ft\123\14
C:\Temp\$0ft\123\15
C:\Temp\$0ft\123\16

C:\Temp\$0ft\123\altgraph-0.17.4-py2.py3-none-any.whl
C:\Temp\$0ft\123\et_xmlfile-1.1.0-py3-none-any.whl
C:\Temp\$0ft\123\greenlet-3.0.3-cp312-cp312-win_amd64.whl
C:\Temp\$0ft\123\openpyxl-3.1.2-py2.py3-none-any.whl
C:\Temp\$0ft\123\packaging-23.2-py3-none-any.whl
C:\Temp\$0ft\123\pefile-2023.2.7-py3-none-any.whl
C:\Temp\$0ft\123\pyinstaller-6.4.0-py3-none-win_amd64.whl
C:\Temp\$0ft\123\pyinstaller_hooks_contrib-2024.2-py2.py3-none-any.whl
C:\Temp\$0ft\123\pywin32_ctypes-0.2.2-py3-none-any.whl
C:\Temp\$0ft\123\requirements.txt
C:\Temp\$0ft\123\setuptools-69.1.1-py3-none-any.whl
C:\Temp\$0ft\123\SQLAlchemy-2.0.28-cp312-cp312-win_amd64.whl
C:\Temp\$0ft\123\tabulate-0.9.0-py3-none-any.whl
C:\Temp\$0ft\123\tk-0.1.0-py3-none-any.whl
C:\Temp\$0ft\123\typing_extensions-4.10.0-py3-none-any.whl
C:\Temp\$0ft\123\wheel-0.42.0-py3-none-any.whl

FilesAndFoldersAfter.csv
FilesAndFoldersBefore.csv



' Create a FileSystemObject
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Define the folder path
strFolder = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Define the CSV file path
strCSV1 = strFolder & "\FilesAndFoldersBefore.csv"
strCSV2 = strFolder & "\FilesAndFoldersAfter.csv"

' Read the original file and folder names from the first CSV file
Set objFile1 = objFSO.OpenTextFile(strCSV1)
arrNames = Split(objFile1.ReadAll, vbCrLf)
objFile1.Close

' Read the new file and folder names from the second CSV file
Set objFile2 = objFSO.OpenTextFile(strCSV2)
arrNewNames = Split(objFile2.ReadAll, vbCrLf)
objFile2.Close

' Loop through each file and folder in the folder
For i = 0 To UBound(arrNames)

	if arrNewNames(i)<> "" then
		'WScript.Echo arrNewNames(i)
		objFso.MoveFile arrNewNames(i), arrNames(i)
	end if

Next

MsgBox "Done!"
