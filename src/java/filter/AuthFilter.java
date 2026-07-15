package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {
    "/admindashboard",
    "/smedashboard",
    "/studentdashboard"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        // 1. Nếu chưa đăng nhập -> Đá bay về trang login
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Nếu đã đăng nhập -> Kiểm tra xem có vào đúng role quy định không
        String uri = req.getRequestURI();
        int roleId = account.getRoleId();

        if (uri.contains("/admindashboard") && roleId != 1) {
            // Đăng nhập rồi nhưng không phải Admin mà đòi vào admin -> Chặn lại
            resp.sendRedirect(req.getContextPath() + "/login?error=LoiPhanQuyen");
            return;
        }

        if (uri.contains("/smedashboard") && roleId != 2) {
            // Không phải SME mà đòi vào SME dashboard
            resp.sendRedirect(req.getContextPath() + "/login?error=LoiPhanQuyen");
            return;
        }

        if (uri.contains("/studentdashboard") && roleId != 3) {
            // Không phải học viên mà đòi vào Student dashboard
            resp.sendRedirect(req.getContextPath() + "/login?error=LoiPhanQuyen");
            return;
        }

        // Mọi thứ hợp lệ -> Cho đi tiếp
        chain.doFilter(request, response);
    }
}
