package find.a.place.kt.views

import find.a.place.kt.models.Listing

object NewListingsView {
    fun show(newListings: List<Listing>) {
        println("Há ${newListings.size} anúncios novos.")
    }
}
