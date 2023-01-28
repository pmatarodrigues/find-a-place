package find.a.place.kt.controllers

import find.a.place.kt.exceptions.Exceptions
import find.a.place.kt.models.Listing
import org.jsoup.nodes.Document

class FetchListingsController {
    fun fetchAllListings(document : Document) : List<Listing> {
        val allListings = mutableListOf<Listing>()
        val labelNumListings = fetchNumListings(document)

        val elements = document.select("article.offer-item")
        elements.forEach{
            val listing = Listing(
                url = it.attr("data-url"),
                name = it.select(".offer-item-details .offer-item-title").text(),
                topology = it.select(".params .offer-item-rooms").text(),
                price = it.select(".params .offer-item-price").text(),
                thumbnailUrl = it.select(".offer-item-image .img-cover").attr("style").substringAfter("background-image: url(").substringBefore(")")
            )

            allListings.add(listing)
        }

        if (allListings.size != labelNumListings)
            throw Exceptions.InconsistentNumberOfListings
        return allListings
    }

    private fun fetchNumListings(document : Document) : Int {
        return document.select(".offers-index strong").text().toInt()
    }
}
