//CECS 342 Section 5
//Lorenzo Murillo IV
using System.Xml.Linq;
using System.Data;


class Project3
{
    //creates an enumeration without side effects, this is how it's typed in c#
    static IEnumerable<string> EnumerableFilesRecursively(string path)
        => Directory.EnumerateFiles(path, "*", SearchOption.AllDirectories);

    static string FormatBySize(long byteSize)
    {
        string[] readableSizes = { "B", "KB", "MB", "GB", "TB", "PB", "ZB" };
        if (byteSize == 0) return "0" + readableSizes[0];
        long bytes = Math.Abs(byteSize);
        int mark = Convert.ToInt32(Math.Floor(Math.Log(bytes, 1024)));
        double number = Math.Round(bytes / Math.Pow(1024, mark), 2);
        return (Math.Sign(byteSize) * number).ToString() + readableSizes[mark];
    }



    static XDocument CreateReport(IEnumerable<string> files)
    {
        var docTable =  from f in files
                        group f by new FileInfo(f).Extension into fileGroup
                        let totalSize = fileGroup.Sum(f => new FileInfo(f).Length)
                        orderby totalSize descending
                        select new
                        {
                            Type = fileGroup.Key,
                            Count = fileGroup.Count(),
                            Size = FormatBySize(totalSize)
                        }; 
    
        XDocument report = new XDocument(new XComment("DOCTYPE html"),
                  new XElement("html",
                  new XElement("head",
                  new XElement("style",
                  new XAttribute("type", "text/css"), " th, td {border: 0.75px solid teal;}"),
                  new XElement("body",
                  new XElement("h1", "Project 3 CECS 342 Lorenzo Murillo IV"),
                  new XElement("table",
                  new XAttribute("style", "width: 50%"),
                  new XAttribute("border", 1),
                  new XElement("tr",
                  new XElement("th", "Type"),
                  new XElement("th", "Count"),
                  new XElement("th", "Size")),
                  new XElement("tr", from row in docTable select 
                  new XElement("tr",
                  new XElement("td", row.Type, new XAttribute("style", "text-align:left")),
                  new XElement("td", row.Count, new XAttribute("style", "text-align:center")),
                  new XElement("td", row.Size, new XAttribute("style", "text-align:center")))))))));

        return report;
    }

    public static void Main(string[] args)
    {
        var path = args[0];
        var fileToSave = args[1];
        var list = EnumerableFilesRecursively(path);
       
        var fileR = CreateReport(list);
        fileR.Save(fileToSave);
        Console.WriteLine("Report Ready");

    }
}
