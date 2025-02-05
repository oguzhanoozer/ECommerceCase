struct MockData {
    static let productsJSON = """
    [
        {
            "id": 1,
            "title": "iPhone 13 Pro",
            "price": 999.99,
            "description": "Latest iPhone model with advanced camera system",
            "category": "electronics",
            "image": "https://example.com/iphone.jpg",
            "rating": {
                "rate": 4.8,
                "count": 250
            }
        },
        {
            "id": 2,
            "title": "MacBook Air M1",
            "price": 1299.99,
            "description": "Thin and light laptop with Apple M1 chip",
            "category": "electronics",
            "image": "https://example.com/macbook.jpg",
            "rating": {
                "rate": 4.9,
                "count": 180
            }
        }
    ]
    """
    
    static let productDetailJSON = """
    {
        "id": 1,
        "title": "iPhone 13 Pro",
        "price": 999.99,
        "description": "Latest iPhone model with advanced camera system. Features include A15 Bionic chip, Pro camera system, ProMotion display, and all-day battery life.",
        "category": "electronics",
        "image": "https://example.com/iphone.jpg",
        "rating": {
            "rate": 4.8,
            "count": 250
        }
    }
    """
} 