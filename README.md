# Courier & Parcel Tracking System (Swing Edition)

A desktop GUI version of the Courier & Parcel Tracking System, built with
plain Java Swing (no CSS/HTML, no external UI frameworks) and MySQL via JDBC.

## Project structure
```
courier-swing-app/
├── schema.sql                     # run this first to create the database
├── lib/                           # put mysql-connector-j-x.x.x.jar here
└── src/courier/
    ├── Main.java                  # entry point
    ├── DBConnection.java          # JDBC connection settings
    ├── model/                     # Parcel, DeliveryStaff
    ├── service/                   # AdminService, CustomerService (JDBC + DSA logic)
    └── ui/                        # LoginFrame, AdminDashboard, CustomerDashboard,
                                    # UITheme, RoundedButton
```

## 1. Set up the database
Open `schema.sql` in MySQL Workbench (or `mysql -u root -p < schema.sql`) and
run the whole script. It creates `courier_db`, all 5 tables, indexes, and a
default admin login:
- Username: `admin`
- Password: `admin123`

## 2. Add the MySQL JDBC driver
Download **mysql-connector-j** (the JDBC driver jar) from MySQL's site and
place the `.jar` file in the `lib/` folder.

## 3. Set your DB password
Edit `src/courier/DBConnection.java` and set `PASS` to your MySQL root
password (or whichever user/password you use).

## 4. Compile
From the project root:
```
javac -cp "lib/*" -d out $(find src -name "*.java")
```

## 5. Run
```
java -cp "out:lib/*" courier.Main        # Linux/Mac
java -cp "out;lib/*" courier.Main        # Windows
```

## UI overview
- **Login screen** — tabs for Admin login and Customer login (with a
  "Register" link for new customers).
- **Admin dashboard** — sidebar navigation: Manage Customers, Manage
  Parcels, Assign Delivery Staff, Update Parcel Status, Delivery Reports.
- **Customer dashboard** — sidebar navigation: Book Parcel, Track Parcel
  (also shows delivery status), Delivery History, Update Profile.

All styling (colors, fonts, rounded buttons, table headers) is done in
plain Java code (`UITheme.java`, `RoundedButton.java`) — no CSS is used
anywhere, since Swing doesn't render HTML/CSS.

## DSA optimizations kept from the console version
- **HashMap cache** in `CustomerService` — O(1) repeat parcel lookups.
- **PriorityQueue (min-heap)** in `AdminService.assignDeliveryStaff` —
  picks the least-loaded available staff member in O(log n).
- **ArrayDeque (stack)** in `CustomerService.getDeliveryHistory` — returns
  history newest-first without a second DB sort.
- All multi-table writes (booking, assignment, status update) run inside
  a JDBC transaction with commit/rollback.
