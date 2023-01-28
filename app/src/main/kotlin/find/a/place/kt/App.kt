package find.a.place.kt

import find.a.place.kt.controllers.FetchListingsController
import find.a.place.kt.views.NewListingsView
import org.jsoup.Jsoup
import org.jsoup.nodes.Document

fun main() {
    val fetchListingsController = FetchListingsController()
    val url = "https://www.imovirtual.com/arrendar/apartamento/lisboa/?search%5Bfilter_enum_rooms_num%5D%5B0%5D=1&search%5Bregion_id%5D=11"
    val document: Document = Jsoup.connect(url).get()

    val newListings = fetchListingsController.fetchAllListings(document)

    NewListingsView.show(newListings)
}