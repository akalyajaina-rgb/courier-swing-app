package courier.model;

public class Parcel {
    public int parcelId, customerId, staffId;
    public String pickup, delivery, status;
    public double weight;

    public Parcel(int parcelId, int customerId, int staffId, String pickup,
                  String delivery, double weight, String status) {
        this.parcelId = parcelId;
        this.customerId = customerId;
        this.staffId = staffId;
        this.pickup = pickup;
        this.delivery = delivery;
        this.weight = weight;
        this.status = status;
    }

    @Override
    public String toString() {
        return String.format("Parcel #%d | %s -> %s | %.2f kg | Status: %s",
                parcelId, pickup, delivery, weight, status);
    }
}
