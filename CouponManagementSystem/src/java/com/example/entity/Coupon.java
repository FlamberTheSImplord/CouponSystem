package com.example.entity;

import java.util.Date;

public class Coupon {
    private int id;
    private String code;
    private String description;
    private double discountAmount;
    private String discountType; // "PERCENTAGE" or "FIXED"
    private Date expiryDate;
    private int usageLimit;
    private int usedCount;
    private boolean isActive;
    private Date createdAt;
    
    // Constructors
    public Coupon() {
        this.createdAt = new Date();
        this.isActive = true;
        this.usedCount = 0;
    }
    
    public Coupon(String code, String description, double discountAmount, 
                  String discountType, Date expiryDate, int usageLimit) {
        this();
        this.code = code;
        this.description = description;
        this.discountAmount = discountAmount;
        this.discountType = discountType;
        this.expiryDate = expiryDate;
        this.usageLimit = usageLimit;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public double getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public String getDiscountType() {
        return discountType;
    }
    
    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }
    
    public Date getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public int getUsageLimit() {
        return usageLimit;
    }
    
    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }
    
    public int getUsedCount() {
        return usedCount;
    }
    
    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
        @Override
    public String toString() {
        return "Coupon{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", description='" + description + '\'' +
                ", discountAmount=" + discountAmount +
                ", discountType='" + discountType + '\'' +
                ", expiryDate=" + expiryDate +
                ", usageLimit=" + usageLimit +
                ", usedCount=" + usedCount +
                ", isActive=" + isActive +
                '}';
    }
}