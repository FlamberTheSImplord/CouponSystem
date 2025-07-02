<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:if test="${coupon != null}">Edit Coupon</c:if><c:if test="${coupon == null}">Add New Coupon</c:if></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .required {
            color: red;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="form-container">
            <div class="text-center mb-4">
                <h2>
                    <c:if test="${coupon != null}">
                        <i class="fas fa-edit"></i> Edit Coupon
                    </c:if>
                    <c:if test="${coupon == null}">
                        <i class="fas fa-plus"></i> Add New Coupon
                    </c:if>
                </h2>
            </div>
            
            <!-- Error Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
            </c:if>
            
            <form action="<c:if test='${coupon != null}'>update</c:if><c:if test='${coupon == null}'>insert</c:if>" method="post">
                
                <!-- Hidden ID for Edit -->
                <c:if test="${coupon != null}">
                    <input type="hidden" name="id" value="<c:out value='${coupon.id}' />" />
                </c:if>
                
                <!-- Coupon Code -->
                <div class="form-group">
                    <label for="code">Coupon Code <span class="required">*</span></label>
                    <input type="text" class="form-control" id="code" name="code" 
                           value="<c:out value='${coupon.code}' />" 
                           placeholder="Enter coupon code (e.g., SAVE20, WELCOME50)"
                           required maxlength="20" pattern="[A-Za-z0-9]+" 
                           title="Only letters and numbers allowed">
                    <small class="form-text text-muted">Only letters and numbers, maximum 20 characters</small>
                </div>
                
                <!-- Description -->
                <div class="form-group">
                    <label for="description">Description <span class="required">*</span></label>
                    <textarea class="form-control" id="description" name="description" 
                              rows="3" placeholder="Enter coupon description" required><c:out value='${coupon.description}' /></textarea>
                </div>
                
                <!-- Discount Type and Amount -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="discountType">Discount Type <span class="required">*</span></label>
                            <select class="form-control" id="discountType" name="discountType" required onchange="updateDiscountLabel()">
                                <option value="">Select Type</option>
                                <option value="PERCENTAGE" <c:if test="${coupon.discountType == 'PERCENTAGE'}">selected</c:if>>Percentage (%)</option>
                                <option value="FIXED" <c:if test="${coupon.discountType == 'FIXED'}">selected</c:if>>Fixed Amount ($)</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="discountAmount" id="discountLabel">Discount Amount <span class="required">*</span></label>
                            <input type="number" class="form-control" id="discountAmount" name="discountAmount" 
                                   value="<c:out value='${coupon.discountAmount}' />" 
                                   placeholder="Enter amount" required step="0.01" min="0.01">
                        </div>
                    </div>
                </div>
                
                <!-- Expiry Date and Usage Limit -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="expiryDate">Expiry Date <span class="required">*</span></label>
                            <input type="date" class="form-control" id="expiryDate" name="expiryDate" 
                                   value="<fmt:formatDate value='${coupon.expiryDate}' pattern='yyyy-MM-dd'/>" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="usageLimit">Usage Limit</label>
                            <input type="number" class="form-control" id="usageLimit" name="usageLimit" 
                                   value="<c:out value='${coupon.usageLimit}' />" 
                                   placeholder="0 for unlimited" min="0">
                            <small class="form-text text-muted">Enter 0 for unlimited usage</small>
                        </div>
                    </div>
                </div>
                
                <!-- Active Status -->
                <div class="form-group">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="isActive" name="isActive" 
                               value="true" <c:if test="${coupon == null || coupon.active}">checked</c:if>>
                        <label class="form-check-label" for="isActive">
                            Active Coupon
                        </label>
                    </div>
                    <small class="form-text text-muted">Inactive coupons cannot be used</small>
                </div>
                
                <!-- Current Usage (Edit mode only) -->
                <c:if test="${coupon != null}">
                    <div class="form-group">
                        <label>Current Usage</label>
                        <div class="form-control-plaintext">
                            Used ${coupon.usedCount} times
                            <c:if test="${coupon.usageLimit > 0}">
                                out of ${coupon.usageLimit} allowed
                            </c:if>
                        </div>
                    </div>
                </c:if>
                
                <!-- Submit Buttons -->
                <div class="form-group text-center">
                    <button type="submit" class="btn btn-success btn-lg mr-3">
                        <i class="fas fa-save"></i>
                        <c:if test="${coupon != null}">Update Coupon</c:if>
                        <c:if test="${coupon == null}">Create Coupon</c:if>
                    </button>
                    <a href="<%=request.getContextPath()%>/list" class="btn btn-secondary btn-lg">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    
    <script>
        // Update discount label based on type selection
        function updateDiscountLabel() {
            var discountType = document.getElementById('discountType').value;
            var label = document.getElementById('discountLabel');
            var input = document.getElementById('discountAmount');
            
            if (discountType === 'PERCENTAGE') {
                label.innerHTML = 'Discount Percentage (%) <span class="required">*</span>';
                input.setAttribute('max', '100');
                input.setAttribute('placeholder', 'Enter percentage (1-100)');
            } else if (discountType === 'FIXED') {
                label.innerHTML = 'Discount Amount ($) <span class="required">*</span>';
                input.removeAttribute('max');
                input.setAttribute('placeholder', 'Enter fixed amount');
            } else {
                label.innerHTML = 'Discount Amount <span class="required">*</span>';
                input.removeAttribute('max');
                input.setAttribute('placeholder', 'Enter amount');
            }
        }
        
        // Set minimum date to today
        document.getElementById('expiryDate').min = new Date().toISOString().split('T')[0];
        
        // Initialize discount label on page load
        updateDiscountLabel();
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            var discountType = document.getElementById('discountType').value;
            var discountAmount = parseFloat(document.getElementById('discountAmount').value);
            
            if (discountType === 'PERCENTAGE' && discountAmount > 100) {
                e.preventDefault();
                alert('Percentage discount cannot exceed 100%');
                return false;
            }
            
            if (discountAmount <= 0) {
                e.preventDefault();
                alert('Discount amount must be greater than 0');
                return false;
            }
            
            // Check if expiry date is in the past
            var expiryDate = new Date(document.getElementById('expiryDate').value);
            var today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (expiryDate < today) {
                if (!confirm('The expiry date is in the past. Do you want to continue?')) {
                    e.preventDefault();
                    return false;
                }
            }
        });
    </script>
</body>
</html>