using System;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using System.Globalization;

namespace RKI
{
    public class RKIPreProcess
    {
        private readonly string fileName;
        private readonly string hashedName;

        public RKIPreProcess(string file)   // constructor
        {
            fileName = file;

            if (!File.Exists(fileName))
                throw new ArgumentOutOfRangeException("fileName", "File don't exist.");

            int ndx = fileName.LastIndexOf('.');
            hashedName = fileName.Remove(ndx) + "_Hashed" + fileName.Substring(ndx);
        }

        public void RemoveFile()  // csv-Datei "hashed" umbenennen
        {
            File.Delete(fileName);
            File.Move(hashedName, fileName);
        }

        public string PreProcessFile()  // File prozessieren
        {
            string s, w;
            bool doit = true;
            string datenstand = "";

            using (StreamReader sr = File.OpenText(fileName))
            {
                using (StreamWriter sw = new StreamWriter(hashedName))
                {
                    using (SHA256 sha256 = SHA256.Create())
                    {
                        // Header-Zeile lesen
                        sr.ReadLine();

                        // ... und jetzt den Rest
                        while ((s = sr.ReadLine()) != null)
                        {
                            var splitted = s.Split(',');

                            if (doit)
                            {
                                datenstand = splitted[10];
                                var sp = datenstand.Split('"');
                                datenstand = sp[1];

                                doit = false;   // den Datenstand nur 1 mal bestimmen
                            }

                            // FID,IdBundesland,Bundesland,Landkreis,Altersgruppe,Geschlecht,AnzahlFall,AnzahlTodesfall,Meldedatum,IdLandkreis,
                            //   0            1          2         3            4          5          6               7          8           9
                            // Datenstand,NeuerFall,NeuerTodesfall,Refdatum,NeuGenesen,AnzahlGenesen,IstErkrankungsbeginn,Altersgruppe2
                            //      10-11        12             13       14         15            16                   17            18

                            // FID und Datenstand ignorieren
                            s = "";
                            for (int n = 1; n <= 9; ++n)
                            {
                                s += splitted[n];
                                s += ",";
                            }
                            for (int n = 12; n <= 17; ++n)
                            {
                                s += splitted[n];
                                s += ",";
                            }
                            s += splitted[18];

                            byte[] bytes = System.Text.Encoding.UTF8.GetBytes(s);
                            byte[] hash = sha256.ComputeHash(bytes);

                            var sBuilder = new StringBuilder();
                            for (int i = 0; i < hash.Length; i++)
                                sBuilder.Append(hash[i].ToString("x2"));

                            w = sBuilder.ToString() + "," + s;
                            sw.WriteLine(w);
                        }
                        return (datenstand);
                    }
                }
            }
        }
    }
}
