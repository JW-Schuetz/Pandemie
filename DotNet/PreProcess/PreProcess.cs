using System;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using System.Globalization;

namespace PreProcess
{
    public class PreProcess
    {
        public static string PreProcessFile(string fileName)
        {
            string ret = "";

            if (!File.Exists(fileName)) return (ret);

            var sp = fileName.Split('.');
            string outName = sp[0] + "-out." + sp[1];

            int cnt;
            string s, w;
            string hashString;
            string datenstand = "";

            using (StreamWriter sw = new StreamWriter(outName))
            {
                using (SHA256 sha256 = SHA256.Create())
                {
                    using (StreamReader sr = File.OpenText(fileName))
                    {
                        // Header-Zeile lesen
                        sr.ReadLine();

                        cnt = 0;

                        // ... und jetzt den Rest
                        while ((s = sr.ReadLine()) != null)
                        {
                            var splitted = s.Split(',');

                            cnt += 1;

                            if (cnt == 1)   // den Datenstand nur 1 mal berechnen
                            {
                                datenstand = splitted[10];
                                sp = datenstand.Split('"');
                                datenstand = sp[1];
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

                            hashString = sBuilder.ToString();

                            w = hashString + "," + s;
                            sw.WriteLine(w);
                        }

                        return (datenstand);
                    }
                }
            }
        }
    }
}
