package repository;

import helper.DBConnect;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {

    // Thêm người dùng mới
    public int add(User user) throws Exception {
        try (Connection conn = DBConnect.getConnection()) {
            String sql = "INSERT INTO loginuser (account, pass, roles, active) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setInt(3, user.getRole()); // ✅ ĐỔI: setInt thay vì setBoolean
            stmt.setBoolean(4, user.isActive());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int generatedId = generatedKeys.getInt(1);
                        user.setId(generatedId);
                    }
                }
            }
            return affectedRows;
        }
    }

    // Lấy tất cả người dùng
    public List<User> getAll() {
        List<User> userList = new ArrayList<>();
        try (Connection conn = DBConnect.getConnection()) {
            String query = "SELECT * FROM loginuser";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("account"));
                user.setPassword(rs.getString("pass"));
                user.setRole(rs.getInt("roles")); // ✅ ĐỔI: getInt thay vì getBoolean
                user.setActive(rs.getBoolean("active"));
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    // Lấy người dùng theo ID
    public User getUserById(int id) throws Exception {
        try (Connection conn = DBConnect.getConnection()) {
            String sql = "SELECT * FROM loginuser WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String username = rs.getString("account");
                String password = rs.getString("pass");
                int role = rs.getInt("roles"); // ✅ ĐỔI: getInt thay vì getBoolean
                boolean active = rs.getBoolean("active");
                return new User(id, username, password, role, active);
            }
        }
        return null;
    }

    // Cập nhật người dùng
    public int update(User user) throws Exception {
        try (Connection conn = DBConnect.getConnection()) {
            String sql = "UPDATE loginuser SET account = ?, pass = ?, roles = ?, active = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setInt(3, user.getRole());
            stmt.setBoolean(4, user.isActive());
            stmt.setInt(5, user.getId());
            return stmt.executeUpdate();
        }
    }

    // Khóa người dùng theo ID
    public int lockUserById(int id) throws Exception {
        try (Connection conn = DBConnect.getConnection()) {
            String sql = "UPDATE loginuser SET active = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setBoolean(1, false);
            stmt.setInt(2, id);
            return stmt.executeUpdate();
        }
    }
}