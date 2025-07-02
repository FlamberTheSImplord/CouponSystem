package com.example.dao;

import com.example.entity.Coupon;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;  

public class CouponDAO {
    
    private String jdbcURL = "jdbc:derby://localhost:1527/coupondb";
    private String jdbcUsername = "";
    private String jdbcPassword = "";
    
    // SQL queries
    private static final String INSERT_COUPON_SQL = 
        "INSERT INTO coupons (code, description, discount_amount, discount_type, expiry_date, usage_limit, used_count, is_active, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
    
    private static final String SELECT_COUPON_BY_ID = 
        "SELECT id, code, description, discount_amount, discount_type, expiry_date, usage_limit, used_count, is_active, created_at FROM coupons WHERE id = ?";
    
    private static final String SELECT_ALL_COUPONS = 
        "SELECT * FROM coupons ORDER BY created_at DESC";
    
    private static final String DELETE_COUPON_SQL = 
        "DELETE FROM coupons WHERE id = ?";
    
    private static final String UPDATE_COUPON_SQL = 
        "UPDATE coupons SET code = ?, description = ?, discount_amount = ?, discount_type = ?, expiry_date = ?, usage_limit = ?, is_active = ? WHERE id = ?";
    
    
    // Database connection
protected Connection getConnection() {
    Connection connection = null;
    try {
        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
        connection = DriverManager.getConnection(jdbcURL);
        System.out.println("Embedded Derby connected!"); // Debug
    } catch (Exception e) {
        System.out.println("Connection failed: " + e.getMessage());
        e.printStackTrace();
    }
    return connection;
}
    
    // CREATE - Insert coupon
    public void insertCoupon(Coupon coupon) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_COUPON_SQL)) {
            
            preparedStatement.setString(1, coupon.getCode());
            preparedStatement.setString(2, coupon.getDescription());
            preparedStatement.setDouble(3, coupon.getDiscountAmount());
            preparedStatement.setString(4, coupon.getDiscountType());
            preparedStatement.setTimestamp(5, new Timestamp(coupon.getExpiryDate().getTime()));
            preparedStatement.setInt(6, coupon.getUsageLimit());
            preparedStatement.setInt(7, coupon.getUsedCount());
            preparedStatement.setBoolean(8, coupon.isActive());
            
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        }
    }
    
    // READ - Select coupon by ID
    public Coupon selectCoupon(int id) {
        Coupon coupon = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COUPON_BY_ID)) {
            
            preparedStatement.setInt(1, id);
            ResultSet rs = preparedStatement.executeQuery();
            
            while (rs.next()) {
                coupon = mapRowToCoupon(rs);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return coupon;
    }
    

    
    // READ - Select all coupons
    public List<Coupon> selectAllCoupons() {
        List<Coupon> coupons = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_COUPONS)) {
            
            ResultSet rs = preparedStatement.executeQuery();
            
            while (rs.next()) {
                coupons.add(mapRowToCoupon(rs));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return coupons;
    }
    
    // UPDATE - Update coupon
    public boolean updateCoupon(Coupon coupon) throws SQLException {
        boolean rowUpdated = false;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_COUPON_SQL)) {
            
            statement.setString(1, coupon.getCode());
            statement.setString(2, coupon.getDescription());
            statement.setDouble(3, coupon.getDiscountAmount());
            statement.setString(4, coupon.getDiscountType());
            statement.setTimestamp(5, new Timestamp(coupon.getExpiryDate().getTime()));
            statement.setInt(6, coupon.getUsageLimit());
            statement.setBoolean(7, coupon.isActive());
            statement.setInt(8, coupon.getId());
            
            rowUpdated = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        }
        return rowUpdated;
    }
    
    // DELETE - Delete coupon
    public boolean deleteCoupon(int id) throws SQLException {
        boolean rowDeleted = false;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_COUPON_SQL)) {
            
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        }
        return rowDeleted;
    }
    

    
    // Helper method to map ResultSet to Coupon object
    private Coupon mapRowToCoupon(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String code = rs.getString("code");
        String description = rs.getString("description");
        double discountAmount = rs.getDouble("discount_amount");
        String discountType = rs.getString("discount_type");
        Date expiryDate = new Date(rs.getTimestamp("expiry_date").getTime());
        int usageLimit = rs.getInt("usage_limit");
        int usedCount = rs.getInt("used_count");
        boolean isActive = rs.getBoolean("is_active");
        Date createdAt = new Date(rs.getTimestamp("created_at").getTime());
        
        Coupon coupon = new Coupon(code, description, discountAmount, discountType, expiryDate, usageLimit);
        coupon.setId(id);
        coupon.setUsedCount(usedCount);
        coupon.setActive(isActive);
        coupon.setCreatedAt(createdAt);
        
        return coupon;
    }
    
    // Utility method to print SQL exceptions
    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.err.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}