package model;

import java.util.List;
import java.util.ArrayList;

public class New {
    private int id;
    private String title;
    private String content;
    private String category;
    private String author;
    private int views;
    private boolean trending;
    private List<String> imagePaths;

    // Constructor đầy đủ với id
    public New(int id, String title, String content, String category, String author, int views, boolean trending, List<String> imagePaths) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.category = category;
        this.author = author;
        this.views = views;
        this.trending = trending;
        this.imagePaths = imagePaths != null ? imagePaths : new ArrayList<>();
    }

    // Constructor không có id (dành cho khi tạo tin tức mới)
    public New(String title, String content, String category, String author, int views, boolean trending, List<String> imagePaths) {
        this.title = title;
        this.content = content;
        this.category = category;
        this.author = author;
        this.views = views;
        this.trending = trending;
        this.imagePaths = imagePaths != null ? imagePaths : new ArrayList<>();
    }

    // Constructor rỗng
    public New() {
        this.imagePaths = new ArrayList<>();
    }

    // Getters và Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public boolean isTrending() {
        return trending;
    }

    public void setTrending(boolean trending) {
        this.trending = trending;
    }

    public List<String> getImagePaths() {
        return imagePaths;
    }

    public void setImagePaths(List<String> imagePaths) {
        this.imagePaths = imagePaths != null ? imagePaths : new ArrayList<>();
    }

    @Override
    public String toString() {
        return "New{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", category='" + category + '\'' +
                ", author='" + author + '\'' +
                ", views=" + views +
                ", trending=" + trending +
                '}';
    }
}