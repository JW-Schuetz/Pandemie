using System;
using System.IO;
using System.Security.Cryptography;


namespace PreProcess
{
    public class PreProcess
    {
        public static int OpenFile( string fileName )
        {
            if ( !File.Exists( fileName ) ) return -1;

            using (SHA256 sha256 = SHA256.Create())
            {
                using (StreamReader sr = File.OpenText(fileName))
                {
                    string s;
                    while ((s=sr.ReadLine()) != null)
                    {
                        var split = s.Split(',');
                        byte[] a = System.Text.Encoding.UTF8.GetBytes(s);
                        byte[] hash = sha256.ComputeHash(a);
                        char[] b = System.Text.Encoding.UTF8.GetChars(hash);
                        string c = b.ToString();
                    }

                    return 0;
                }
            }
        }
    }
}
