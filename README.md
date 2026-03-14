# 📰 News Management System - JAV101 Assignment

## 📝 Giới thiệu dự án
Dự án được xây dựng nhằm giải quyết bài toán quản lý tin tức tập trung, áp dụng các kỹ thuật lập trình hướng đối tượng (OOP) trên ngôn ngữ **Java**. Điểm nhấn của hệ thống là khả năng **phân quyền người dùng (Role-based Access Control)**, giúp kiểm soát chặt chẽ các thao tác dữ liệu tùy theo vị trí công việc.

---

## 🔐 Hệ thống Phân quyền (3 Roles)
Chương trình phân tách rõ rệt quyền hạn giữa các nhóm người dùng để đảm bảo tính bảo mật và luồng công việc:

| Vai trò (Role) | Quyền hạn chính |
| :--- | :--- |
| **Super Admin** | Toàn quyền hệ thống: Quản lý tài khoản (Thêm/Sửa/Xóa người dùng), quản lý chuyên mục tin tức. |
| **Admin** | Quản lý nội dung: Viết bài mới, chỉnh sửa bài viết và cập nhật trạng thái các tin tức hiện có. |
| **User** | Người xem: Đọc tin tức, tìm kiếm bài viết và tham gia đánh giá (Rating) nội dung. |

---

## 🚀 Tính năng nổi bật
* **Xác thực (Authentication):** Hệ thống đăng nhập để điều hướng vào Menu chức năng riêng biệt cho từng Role.
* **Quản lý Tin tức:** CRUD bài viết, xử lý logic tính điểm trung bình đánh giá (`AverageRate`).
* **Tìm kiếm thông minh:** Lọc tin tức nhanh chóng theo tiêu đề, tác giả hoặc chuyên mục.
* **Kiến trúc OOP:** * Sử dụng **Inheritance** (Kế thừa) để tối ưu hóa quản lý các nhóm User.
    * Sử dụng **Interface/Abstract** để định nghĩa quy chuẩn hiển thị tin tức.
    * Quản lý dữ liệu động linh hoạt với **ArrayList**.

---

## 📂 Cấu trúc mã nguồn
* `model/`: Định nghĩa các lớp đối tượng (`News`, `User`, `Admin`, `Editor`, `Category`).
* `service/`: Xử lý logic nghiệp vụ (Xác thực, tính toán điểm, quản lý danh sách).
* `main/`: Chạy chương trình, hiển thị Console và điều hướng Menu.
