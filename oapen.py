import xlsxwriter
import datetime
import yaml
import pyPdf



pagecount = pyPdf.PdfFileReader(open("main.pdf")).getNumPages() 

metadata =  open('metadata.yaml')
dataMap = yaml.safe_load(metadata) 
bookid = dataMap["bookid"] 

creators = dataMap["creators"] 
try:
  creatorstring = "; ".join(["%s, %s"%(x[1],x[0]) for x in creators["authors"]] )
except TypeError:
  creatorstring = "; ".join(["%s, %s"%(x[1],x[0]) for x in creators["editors"]] )

oapenlist=(
("Title",dataMap["title"]),
("Author(s)/Editor(s)",creatorstring),
("BIC classification(s)",""),
("English keywords",""),
("Keywords in other languages",""),
("Publisher","Language Science Press"),
("Year of publication",datetime.datetime.now().year),
("Place of publication","Berlin"),
("ISBN",dataMap["isbns"][0][1]),
("Imprint",""),
("Abstract in English",dataMap["blurb"]),
("Abstract in other languages",""),
("Language of the publication",""),
("Title of the series",""),
("Number within the series",dataMap["seriesnumber"]),
#("ISSN of the series",),
("Number of pages",pagecount),
("Rights","CC-BY"),
("Link to web shop","http://www.langsci-press.org/catalog/book/%s"%bookid),
("Funder",""),
("Grant number","")  
  )

workbook = xlsxwriter.Workbook('oapen-langsci-%s.xlsx'%bookid)
worksheet = workbook.add_worksheet()
for i, (k,v) in enumerate(oapenlist): 
  #k,v = x
  worksheet.write(i, 0, k)
  worksheet.write(i, 1, v)
 

workbook.close()