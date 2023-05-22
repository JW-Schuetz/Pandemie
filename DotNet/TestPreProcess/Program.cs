using System;
using System.IO;
using RKI;

namespace TestPreProcess
{
    class TestPreProcess
    {
        static void Main( string[] args )
        {
            //string fileName = "D:\\Projekte\\Pandemie\\RKI_COVID19.csv";
            string fileName = "..\\..\\..\\..\\RKI_COVID19.csv";
            RKIPreProcess ret = new RKIPreProcess(fileName);
            string datenstand = ret.PreProcessFile();
//          ret.RemoveFile();
        }
    }
}