package findMyClub;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_URL =
        "jdbc:mysql://127.0.0.1:3306/findmyclub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String DB_USER = "root";
    private static final String DB_PASS = "Asian2004Mtg429";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] MySQL driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
}