

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.io.Reader;


public class SubstTest {
	private static final String OUTPUT_FILE = "src/resources/output.txt";

	public static void main(String[] args) throws IOException {
		// the standalon Subst prints status on stdout
		// redirecte it into a file
		String[] argv = new String[1];
		argv[0] = "src/resources/input.txt";
		File actual = new File(OUTPUT_FILE);
		actual.delete();
		FileOutputStream fos = new FileOutputStream(OUTPUT_FILE, true);
		System.setOut(new PrintStream(fos));

		JavascriptLexer.main(argv);

		fos.close();
	}
}
