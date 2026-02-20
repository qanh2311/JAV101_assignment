package helper;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.microsoft.sqlserver.jdbc.SQLServerDataSource;
public class DBConnect {
    private static Connection conn;

    public static Connection getConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String dbUser = "sa", dbPass = "123456789",
                        dbUrl = "jdbc:sqlserver://localhost:1433;" +
                                "databaseName=TH05962;" +
                                "encrypt=true;trustServerCertificate=true;";
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                System.out.println("Kết nối thành công");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    public static void main(String[] args) {
        getConnection();
    }
}

