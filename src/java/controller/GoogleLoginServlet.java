/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Admin
 */
public class GoogleLoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet GoogleLoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GoogleLoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

// Chưa chọn tài khoản -> mở trang chọn Google account
        if (email == null || email.trim().isEmpty()) {

            request.getRequestDispatcher("googlelogin.jsp")
                    .forward(request, response);

            return;

        }

        try {

            UserDAO dao = new UserDAO();

            User user = dao.getUserByEmail(email);

// Không tìm thấy tài khoản
            if (user == null) {

                request.setAttribute("error", "Google account does not exist!");

                request.getRequestDispatcher("googlelogin.jsp")
                        .forward(request, response);

                return;

            }

// Tài khoản bị khóa
            if (!"Active".equalsIgnoreCase(user.getStatus())) {

                request.setAttribute("error", "Your account has been deactivated!");

                request.getRequestDispatcher("googlelogin.jsp")
                        .forward(request, response);

                return;

            }

// Lưu session
            HttpSession session = request.getSession();

            session.setAttribute("account", user);

// Redirect theo role
            switch (user.getRoleId()) {

// Admin
                case 1:

                    response.sendRedirect(request.getContextPath()
                            + "/admindashboard");

                    break;

// SME
                case 2:

                    response.sendRedirect(request.getContextPath()
                            + "/smedashboard");

                    break;

// Student
                case 3:

                    response.sendRedirect(request.getContextPath()
                            + "/studentdashboard");

                    break;

                default:

                    session.invalidate();

                    request.setAttribute("error", "Role is not supported!");

                    request.getRequestDispatcher("googlelogin.jsp")
                            .forward(request, response);

            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("error",
                    "System error: " + e.getMessage());

            request.getRequestDispatcher("googlelogin.jsp")
                    .forward(request, response);

        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
