$excel = New-Object -ComObject Excel.Application
$workbook = $excel.workbooks.add()
$worksheet = $workbook.worksheets.add()
#$workbook.name = "services"
$worksheet.name = "first"
$count = ($worksheet.usedrange.rows).count
$worksheet.cells.item(1,1) = "name"
$worksheet.cells.item(1,2) = "status"
$worksheet.cells.item(1,3) = "id"
$path = "C:\Users\piyush_verma\Desktop\ex1.xlsx"
$workbook.saveAs($path)
$workbooks.close()
$excel.quit()