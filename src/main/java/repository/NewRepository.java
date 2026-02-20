package repository;

import helper.DBConnect;
import model.New;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewRepository {

    /**
     * Thêm tin tức mới (bao gồm cả ảnh)
     */
    public int add(New newRecord) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement imageStmt = null;

        try {
            conn = DBConnect.getConnection();

            String sql = "INSERT INTO new (title, content, category, author, views, trending) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, newRecord.getTitle());
            stmt.setString(2, newRecord.getContent());
            stmt.setString(3, newRecord.getCategory());
            stmt.setString(4, newRecord.getAuthor());
            stmt.setInt(5, newRecord.getViews());
            stmt.setBoolean(6, newRecord.isTrending());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int newId = generatedKeys.getInt(1);

                    // Xử lý ảnh nếu có
                    if (newRecord.getImagePaths() != null && !newRecord.getImagePaths().isEmpty()) {
                        String imageQuery = "INSERT INTO imagegallery (new_id, image_path) VALUES (?, ?)";
                        imageStmt = conn.prepareStatement(imageQuery);

                        for (String imagePath : newRecord.getImagePaths()) {
                            imageStmt.setInt(1, newId);
                            imageStmt.setString(2, imagePath);
                            imageStmt.executeUpdate();
                        }
                    }
                }
            }
            return affectedRows;

        } finally {
            if (imageStmt != null) imageStmt.close();
            if (stmt != null) stmt.close();
        }
    }

    /**
     * Lấy danh sách tất cả tin tức
     */
    public List<New> getAll() throws Exception {
        List<New> newsList = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM new ORDER BY id DESC");

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String content = rs.getString("content");
                String category = rs.getString("category");
                String author = rs.getString("author");
                int views = rs.getInt("views");
                boolean trending = rs.getBoolean("trending");

                List<String> imagePaths = getImagesForNew(id);

                New newRecord = new New(id, title, content, category, author, views, trending, imagePaths);
                newsList.add(newRecord);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }

        return newsList;
    }

    /**
     * Lấy tin tức theo ID
     */
    public New getNewById(int id) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT * FROM new WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String title = rs.getString("title");
                String content = rs.getString("content");
                String category = rs.getString("category");
                String author = rs.getString("author");
                int views = rs.getInt("views");
                boolean trending = rs.getBoolean("trending");

                List<String> imagePaths = getImagesForNew(id);

                return new New(id, title, content, category, author, views, trending, imagePaths);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }

        return null;
    }

    /**
     * Cập nhật tin tức (bao gồm ảnh)
     */
    public int update(New newRecord) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement imageStmt = null;

        try {
            conn = DBConnect.getConnection();

            String sql = "UPDATE new SET title = ?, content = ?, category = ?, author = ?, views = ?, trending = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newRecord.getTitle());
            stmt.setString(2, newRecord.getContent());
            stmt.setString(3, newRecord.getCategory());
            stmt.setString(4, newRecord.getAuthor());
            stmt.setInt(5, newRecord.getViews());
            stmt.setBoolean(6, newRecord.isTrending());
            stmt.setInt(7, newRecord.getId());

            int affectedRows = stmt.executeUpdate();

            // Cập nhật ảnh mới nếu có
            if (newRecord.getImagePaths() != null && !newRecord.getImagePaths().isEmpty()) {
                deleteImagesForNew(newRecord.getId());  // Xóa ảnh cũ

                String imageQuery = "INSERT INTO imagegallery (new_id, image_path) VALUES (?, ?)";
                imageStmt = conn.prepareStatement(imageQuery);

                for (String imagePath : newRecord.getImagePaths()) {
                    imageStmt.setInt(1, newRecord.getId());
                    imageStmt.setString(2, imagePath);
                    imageStmt.executeUpdate();
                }
            }

            return affectedRows;

        } finally {
            if (imageStmt != null) imageStmt.close();
            if (stmt != null) stmt.close();
        }
    }

    /**
     * Xóa tin tức theo ID
     */
    public int deleteById(int id) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnect.getConnection();

            // Xóa ảnh trước
            deleteImagesForNew(id);

            // Sau đó xóa tin tức
            String sql = "DELETE FROM new WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);

            return stmt.executeUpdate();

        } finally {
            if (stmt != null) stmt.close();
        }
    }

    /**
     * Xóa ảnh cũ khi cập nhật
     */
    private void deleteImagesForNew(int newId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnect.getConnection();
            String deleteImagesSql = "DELETE FROM imagegallery WHERE new_id = ?";
            stmt = conn.prepareStatement(deleteImagesSql);
            stmt.setInt(1, newId);
            stmt.executeUpdate();

        } finally {
            if (stmt != null) stmt.close();
        }
    }

    /**
     * Lấy ảnh liên quan đến tin tức theo ID
     */
    private List<String> getImagesForNew(int newId) throws SQLException {
        List<String> imagePaths = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT image_path FROM imagegallery WHERE new_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                imagePaths.add(rs.getString("image_path"));
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }

        return imagePaths;
    }

    /**
     * Lấy tin tức theo category
     */
    public List<New> getByCategory(String category) throws Exception {
        List<New> newsList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT * FROM new WHERE category = ? ORDER BY id DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, category);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String content = rs.getString("content");
                String author = rs.getString("author");
                int views = rs.getInt("views");
                boolean trending = rs.getBoolean("trending");

                List<String> imagePaths = getImagesForNew(id);

                New newRecord = new New(id, title, content, category, author, views, trending, imagePaths);
                newsList.add(newRecord);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }

        return newsList;
    }

    /**
     * Lấy tin tức trending
     */
    public List<New> getTrending() throws Exception {
        List<New> newsList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT * FROM new WHERE trending = 1 ORDER BY views DESC, id DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String content = rs.getString("content");
                String category = rs.getString("category");
                String author = rs.getString("author");
                int views = rs.getInt("views");
                boolean trending = rs.getBoolean("trending");

                List<String> imagePaths = getImagesForNew(id);

                New newRecord = new New(id, title, content, category, author, views, trending, imagePaths);
                newsList.add(newRecord);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }

        return newsList;
    }

    /**
     * Tìm kiếm tin tức theo từ khóa (title, content, category, author)
     */
    public List<New> search(String keyword) throws Exception {
        List<New> newsList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnect.getConnection();
            String sql = "SELECT * FROM new WHERE " +
                    "title LIKE ? OR " +
                    "content LIKE ? OR " +
                    "category LIKE ? OR " +
                    "author LIKE ? " +
                    "ORDER BY id DESC";

            stmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            rs = stmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String content = rs.getString("content");
                String category = rs.getString("category");
                String author = rs.getString("author");
                int views = rs.getInt("views");
                boolean trending = rs.getBoolean("trending");

                List<String> imagePaths = getImagesForNew(id);

                New newRecord = new New(id, title, content, category, author, views, trending, imagePaths);
                newsList.add(newRecord);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }

        return newsList;
    }
}