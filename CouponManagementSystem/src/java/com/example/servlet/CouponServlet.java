package com.example.servlet;

import com.example.dao.CouponDAO;
import com.example.entity.Coupon;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class CouponServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CouponDAO couponDAO;
    
    public void init() {
        couponDAO = new CouponDAO();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertCoupon(request, response);
                    break;
                case "/delete":
                    deleteCoupon(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateCoupon(request, response);
                    break;
                case "/view":
                    viewCoupon(request, response);
                    break;
                default:
                    listCoupons(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void listCoupons(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Coupon> listCoupons = couponDAO.selectAllCoupons();
        request.setAttribute("listCoupons", listCoupons);
        RequestDispatcher dispatcher = request.getRequestDispatcher("coupon-list.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("coupon-form.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Coupon existingCoupon = couponDAO.selectCoupon(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("coupon-form.jsp");
        request.setAttribute("coupon", existingCoupon);
        dispatcher.forward(request, response);
    }
    
    private void insertCoupon(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        try {
            String code = request.getParameter("code");
            String description = request.getParameter("description");
            double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
            String discountType = request.getParameter("discountType");
            String expiryDateStr = request.getParameter("expiryDate");
            int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expiryDate = sdf.parse(expiryDateStr);
            
            Coupon newCoupon = new Coupon(code, description, discountAmount, discountType, expiryDate, usageLimit);
            newCoupon.setActive(isActive);
            
            couponDAO.insertCoupon(newCoupon);
            request.setAttribute("message", "Coupon created successfully!");
            
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in discount amount or usage limit.");
        } catch (Exception e) {
            request.setAttribute("error", "Error creating coupon: " + e.getMessage());
        }
        
        response.sendRedirect("list");
    }
    
    private void updateCoupon(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String code = request.getParameter("code");
            String description = request.getParameter("description");
            double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
            String discountType = request.getParameter("discountType");
            String expiryDateStr = request.getParameter("expiryDate");
            int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expiryDate = sdf.parse(expiryDateStr);
            
            Coupon coupon = new Coupon(code, description, discountAmount, discountType, expiryDate, usageLimit);
            coupon.setId(id);
            coupon.setActive(isActive);
            
            couponDAO.updateCoupon(coupon);
            request.setAttribute("message", "Coupon updated successfully!");
            
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in discount amount or usage limit.");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating coupon: " + e.getMessage());
        }
        
        response.sendRedirect("list");
    }
    
    private void deleteCoupon(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            couponDAO.deleteCoupon(id);
            request.getSession().setAttribute("message", "Coupon deleted successfully!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error deleting coupon: " + e.getMessage());
        }
        response.sendRedirect("list");
    }
    
    private void viewCoupon(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Coupon coupon = couponDAO.selectCoupon(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("coupon-view.jsp");
        request.setAttribute("coupon", coupon);
        dispatcher.forward(request, response);
    }
}