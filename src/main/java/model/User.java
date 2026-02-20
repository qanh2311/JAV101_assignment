package model;

public class User {
    private int id;
    private String username;
    private String password;
    private int role;  // ✅ ĐỔI: 0=User, 1=Admin, 2=Super Admin
    private boolean active;

    // Constructor không có id
    public User(String username, String password, int role, boolean active) {
        this.username = username;
        this.password = password;
        this.role = role;
        this.active = active;
    }

    // Constructor có id
    public User(int id, String username, String password, int role, boolean active) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.active = active;
    }

    public User() {}

    // Getters và Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isUser() {
        return role == 0;
    }

    public boolean isAdmin() {
        return role == 1;
    }

    public boolean isSuperAdmin() {
        return role == 2;
    }

    public boolean hasAdminAccess() {
        return role >= 1; // Admin hoặc Super Admin
    }

    public boolean hasSuperAdminAccess() {
        return role == 2;
    }

    public String getRoleName() {
        switch (role) {
            case 0: return "User";
            case 1: return "Admin";
            case 2: return "Super Admin";
            default: return "Unknown";
        }
    }
}