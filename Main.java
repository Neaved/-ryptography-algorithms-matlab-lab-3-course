package hill_cipher;

import java.io.File;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Scanner;
import org.jblas.DoubleMatrix;
import org.jblas.Solve;

public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
    	BigInteger p  = new BigInteger("369ab6b8b5e2a76335c3a581fb722ffcb01ed50d1121ddbb36a5db098a98acf2b0a10b9671e1f39b2535f7392f96409459b5e63276898b9805912e2305b6228859f7401f59da2fe87cbc8f0e92966f2268c5a1349821856256fcc140d973b4c9bb69776c3cc70e1fc4b4f924aef3837dc0f7fcfa3a7b9161cef696fdfdcbfb990e41d819746d3480206826d64afa98d19a991c751fa1ef7d3342fe33d48b0a4626cbb713",16);
    	BigInteger q  = new BigInteger("42b9bc4baa6a2bfefbf6e90d229c9aa4ba785b3606a37d4f1",16);
    	BigInteger g = new BigInteger("31d72a1540e857147c58d5da614101e58ec8b15efba9d9a376b8e9aead1e2e06e7766c6f50dc70c482790611e303a37f85cad321fb59d5b0c8759f4fbb5a73769b66e6ad53a3030fe42507ba89fb574ffd85e8a6fdaa885983ec4d5f5d1529b91f21f9617481e5ff2652645a90f87587e2e20f2510b8234b29d1f0d1ce8c4b9675667ce6ace28d5b6e647076294c6a8ffffaf66c4e5a2752f0c6cd3e7f394065b4efaed9",16);
    	BigInteger m = new BigInteger("3dbf8416a016511881599e8395deb2b231f9a109a77ac8a69",16);
    	BigInteger d = new BigInteger("1cac3d4e761316caddb50e513ed27cb38c23f37e070693e0f",16); 
    	//BigInteger e = new BigInteger("22483a7d679a5ce9b3e856b5c203f8bfcb2e4b112be86022c2741dffd38ed32bde9320f35e789617dcda80edcf2c187165a3d13d924503e55b2b1a70148100574ab9f6cf924a5c2758c7658f7f5dae8a6bc93986cc25c4c0b335e2b791e0cde421e5f8ccb3321a3a2275b9975352ad32e2a86f123d87a5152b5f425d8b8299a3ce4b951e7c0090e02edabb6b5e297998394dd6cf444244b512a706756841592d3b823a63",16);
    	//BigInteger r = new BigInteger("3c879cc1bdf4ca6e4323aa87c024eafc0351f2a109a19c4e33c214d2a8373e006337112f0a5463d770220531d1a61dca081e25bd8844a487b6d35772d5e03133ac1f8e52556733bf251e449d25a2b65d2c7b115628f192f90719fb40fcb999bb4154b3c7c4eb0182b30abd6857885d240826baa31717b122f00fff1ff127e1c28500ccdc07badaae11e5bcaa38db7b94c1fd50ab954a83f6dd45d11aa1d2ca42001f8bf",16);
    	//BigInteger s  = new BigInteger("2a302708f5c43e9fcebd51addcb06344509f8624b929edb4a",16);
    	BigInteger k  = new BigInteger("b0928f8bcf9db5fa1b6212c45f7e5e3db6bc59445e3cbfae",16);
    	//System.out.println(check(p,g,m,e,r,s));
    	System.out.println(k.compareTo(new BigInteger("1",16))==1 && q.compareTo(k)==1);
    	BigInteger r = g.modPow(k, p);
    	BigInteger s = (k.modPow(new BigInteger("-1",10),q).multiply( m.subtract(d.multiply(r)).mod(q))).mod(q);
    	System.out.println("*******************\n* GENERATED (r,s) *\n*******************");
    	System.out.println(r.toString(16));
    	System.out.println(s.toString(16));
    	BigInteger e = g.modPow(d, p);
    	System.out.println("\nCheck: "+check(p,g,m,e,r,s));

    }
    static boolean check(BigInteger p,BigInteger g,BigInteger m,BigInteger e,BigInteger r,BigInteger s)
    {
    	if (!(r.compareTo(new BigInteger("1",16)) == 1 && p.subtract(new BigInteger("1",16)).compareTo(r) == 1))
    	{
    		return false;
    	}
    	if ((r.modPow(s, p).multiply(e.modPow(r, p))).mod(p).compareTo(g.modPow(m, p))!=0)
    	{
    		return false;
    	}
    	return true;
    } 
    
}