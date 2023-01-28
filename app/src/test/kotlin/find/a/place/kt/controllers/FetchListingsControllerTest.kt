package find.a.place.kt.controllers

import find.a.place.kt.models.Listing
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.nodes.Element
import org.jsoup.select.Elements
import org.junit.jupiter.api.Test
import org.mockito.Mockito.`when`
import org.mockito.kotlin.mock
import kotlin.test.assertEquals

class `#fetchAllListings`() {
    val subject = FetchListingsController()
    val listing = Listing(
        url = "url",
        name = "name",
        topology = "topology",
        price = "21.2",
        thumbnailUrl = "thumbnailUrl"
    )
    val listings = listOf<Listing>(
        listing
    )

    @Test
    fun `when label has the same number of fetched listings it should return the listings`() {
        val mockJsoup : Jsoup = mock()
        val mockDoc : Document = mock()
        val mockElements : Elements = mock()
        val mockElement : Element = mock()

        val element = mockDoc.select("article.offer-item")[0]

        `when`(mockDoc.select("article.offer-item")).thenReturn(mockElements)
        `when`(mockElements[0]).thenReturn(mockElement)
        `when`(element.select(".offer-item-details .offer-item-title")).thenReturn(mockElements)
        `when`(element.select(".params .offer-item-rooms")).thenReturn(mockElements)
        `when`(element.select(".params .offer-item-price")).thenReturn(mockElements)

        `when`(element.attr("data-url")).thenReturn(listing.url)
        `when`(element.select(".offer-item-details .offer-item-title").text()).thenReturn(listing.name)
        `when`(element.select(".params .offer-item-rooms").text()).thenReturn(listing.topology)
        `when`(element.select(".params .offer-item-price").text()).thenReturn(listing.price)
        `when`(element.select(".offer-item-image .img-cover").attr("style").substringAfter("background-image: url(").substringBefore(")")).thenReturn(listing.thumbnailUrl)

        val result = subject.fetchAllListings(mockDoc)

        assertEquals(result[0], listings[0])
    }

    /*
    fun `when label does not have the same number of fetched listings it should throw InconsistentNumberOfListings`() {
        // create a mock of the jsoup object
        val mockJsoup : Jsoup = mock()

        // define the behavior of the mock object
        val doc : Document = mock()
        `when`(doc.select("article.offer-item")[0].attr("data-url")).thenReturn(listing.url)
        `when`(doc.select("article.offer-item")[0].select(".offer-item-details .offer-item-title").text()).thenReturn(listing.name)
        `when`(doc.select("article.offer-item")[0].select(".params .offer-item-rooms").text()).thenReturn(listing.topology)
        `when`(doc.select("article.offer-item")[0].select(".params .offer-item-price").text()).thenReturn(listing.price)
        `when`(doc.select("article.offer-item")[0].select(".offer-item-image .img-cover").attr("style").substringAfter("background-image: url(").substringBefore(")")).thenReturn(listing.thumbnailUrl)

        assertThrows(Exceptions.InconsistentNumberOfListings) <(labelNumListings = 2, newListingsSize = listings.size)>{
            subject.fetchAllListings(doc)
        }
    }*/
}