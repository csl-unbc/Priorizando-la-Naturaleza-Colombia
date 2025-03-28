% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class_MapManager.R
\name{MapManager}
\alias{MapManager}
\title{Map manager class}
\description{
Map manager class

Map manager class
}
\details{
Definition for the \code{MapManager} class.

The argument to \code{value} should be a \code{list} with the following elements:
\describe{
\item{id}{\code{character} (optional) name of layer.}
\item{setting}{\code{character} name of setting.
Available options are: \code{"order"}, \code{"feature_order"} and \code{"visible"}.
Note that the \code{"id"} element is required for \code{"feature_order"}
and \code{"visible"} settings.}
}

\describe{
\item{id}{\code{character} (optional) identifier for layer.}
\item{setting}{\code{character} name of setting.
Available options are:
\code{"order"}, "remove"\verb{, }"visible"\verb{, }"feature_order"\verb{, }"feature_visible"\verb{. Note that the }"id"\verb{element is required for}"remove"\verb{, }"visible"\verb{, }"feature_order"\verb{, }"feature_visible"\verb{ settings.\} \\item\{value\}\{}numeric\code{or}logical` value for new setting.}
}
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{layers}}{\code{list} of \link{Theme}, \link{Weight}, \link{Include}, \link{Exclude}, \link{Solution} objects.}

\item{\code{ids}}{\code{character} vector of identifiers for the layers.}

\item{\code{order}}{\code{numeric} vector indicating the order each layer
should appear on them map. A value of 1 indicates that a layer should
appear beneath every other layer.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-MapManager-new}{\code{MapManager$new()}}
\item \href{#method-MapManager-print}{\code{MapManager$print()}}
\item \href{#method-MapManager-repr}{\code{MapManager$repr()}}
\item \href{#method-MapManager-get_order}{\code{MapManager$get_order()}}
\item \href{#method-MapManager-get_layer}{\code{MapManager$get_layer()}}
\item \href{#method-MapManager-get_layer_names}{\code{MapManager$get_layer_names()}}
\item \href{#method-MapManager-get_layer_indices}{\code{MapManager$get_layer_indices()}}
\item \href{#method-MapManager-get_layer_ids}{\code{MapManager$get_layer_ids()}}
\item \href{#method-MapManager-get_layer_panes}{\code{MapManager$get_layer_panes()}}
\item \href{#method-MapManager-get_layer_visible}{\code{MapManager$get_layer_visible()}}
\item \href{#method-MapManager-get_layer_invisible}{\code{MapManager$get_layer_invisible()}}
\item \href{#method-MapManager-get_layer_loaded}{\code{MapManager$get_layer_loaded()}}
\item \href{#method-MapManager-get_setting}{\code{MapManager$get_setting()}}
\item \href{#method-MapManager-set_order}{\code{MapManager$set_order()}}
\item \href{#method-MapManager-set_visible}{\code{MapManager$set_visible()}}
\item \href{#method-MapManager-set_loaded}{\code{MapManager$set_loaded()}}
\item \href{#method-MapManager-set_setting}{\code{MapManager$set_setting()}}
\item \href{#method-MapManager-add_layer}{\code{MapManager$add_layer()}}
\item \href{#method-MapManager-drop_layer}{\code{MapManager$drop_layer()}}
\item \href{#method-MapManager-get_widget_data}{\code{MapManager$get_widget_data()}}
\item \href{#method-MapManager-get_group_layer_ids}{\code{MapManager$get_group_layer_ids()}}
\item \href{#method-MapManager-get_layer_classes}{\code{MapManager$get_layer_classes()}}
\item \href{#method-MapManager-get_lazyload}{\code{MapManager$get_lazyload()}}
\item \href{#method-MapManager-initialize_map}{\code{MapManager$initialize_map()}}
\item \href{#method-MapManager-update_map}{\code{MapManager$update_map()}}
\item \href{#method-MapManager-delete_sinlge_map_pane}{\code{MapManager$delete_sinlge_map_pane()}}
\item \href{#method-MapManager-delete_all_map_panes}{\code{MapManager$delete_all_map_panes()}}
\item \href{#method-MapManager-clone}{\code{MapManager$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-new"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-new}{}}}
\subsection{Method \code{new()}}{
Create a \code{MapManager} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$new(layers, order)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{layers}}{\code{list} of \link{Theme}, \link{Weight}, \link{Include}, \link{Exclude}, \link{Solution}
objects.}

\item{\code{order}}{\code{numeric} vector.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new \code{MapManager} object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-print"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-print}{}}}
\subsection{Method \code{print()}}{
Print the object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$print(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{not used.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-repr"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-repr}{}}}
\subsection{Method \code{repr()}}{
Generate a \code{character} summarizing the representation of the object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$repr()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} value.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_order"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_order}{}}}
\subsection{Method \code{get_order()}}{
Get information on the plot order of each layer.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_order()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer}{}}}
\subsection{Method \code{get_layer()}}{
Get a layer.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer(value)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{character} layer identifier.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{Theme} object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_names"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_names}{}}}
\subsection{Method \code{get_layer_names()}}{
Get layer names.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_names(download_only)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{download_only}}{Get only layer names that are flagged as downloadable.
Available options are \code{TRUE} or \code{FALSE}.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{character} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_indices"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_indices}{}}}
\subsection{Method \code{get_layer_indices()}}{
Get layer index values.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_indices(download_only)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{download_only}}{Get only layer indices that are flagged as downloadable.
Available options are \code{TRUE} or \code{FALSE}.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{character} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_ids"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_ids}{}}}
\subsection{Method \code{get_layer_ids()}}{
Get layer ids values.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_ids()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_panes"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_panes}{}}}
\subsection{Method \code{get_layer_panes()}}{
Get panes.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_panes()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_visible"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_visible}{}}}
\subsection{Method \code{get_layer_visible()}}{
Get layer visible values.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_visible()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_invisible"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_invisible}{}}}
\subsection{Method \code{get_layer_invisible()}}{
Get layer invisible values.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_invisible()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{date/time} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_loaded"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_loaded}{}}}
\subsection{Method \code{get_layer_loaded()}}{
Get layer loaded values.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_loaded()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{logical} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_setting"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_setting}{}}}
\subsection{Method \code{get_setting()}}{
Get a setting for the object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_setting(value)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{list} with setting information (see Details section)}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-set_order"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-set_order}{}}}
\subsection{Method \code{set_order()}}{
Set information on the plot order of each layer.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$set_order(value)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{logical} vector indicating if each layer is visible or not.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-set_visible"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-set_visible}{}}}
\subsection{Method \code{set_visible()}}{
Set visibility for all layers.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$set_visible(value)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{logical} vector indicating if layers should be visible or
not.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-set_loaded"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-set_loaded}{}}}
\subsection{Method \code{set_loaded()}}{
Set loaded for all layers.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$set_loaded(value)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{logical} vector indicating if layers are loaded or
not.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-set_setting"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-set_setting}{}}}
\subsection{Method \code{set_setting()}}{
Set a setting for the object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$set_setting(value)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{list} with new setting information (see Details section)}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-add_layer"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-add_layer}{}}}
\subsection{Method \code{add_layer()}}{
Add a new layer.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$add_layer(value, map)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{Layer} object.}

\item{\code{map}}{\code{\link[leaflet:leafletProxy]{leaflet::leafletProxy()}} object.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-drop_layer"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-drop_layer}{}}}
\subsection{Method \code{drop_layer()}}{
Remove a layer.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$drop_layer(value, map)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{value}}{\code{character} layer identifier.}

\item{\code{map}}{\code{\link[leaflet:leafletProxy]{leaflet::leafletProxy()}} object.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_widget_data"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_widget_data}{}}}
\subsection{Method \code{get_widget_data()}}{
Get data for displaying the theme in a \code{\link[=mapManager]{mapManager()}} widget.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_widget_data()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{list} with widget data.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_group_layer_ids"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_group_layer_ids}{}}}
\subsection{Method \code{get_group_layer_ids()}}{
Get group layer ids.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_group_layer_ids()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_layer_classes"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_layer_classes}{}}}
\subsection{Method \code{get_layer_classes()}}{
Get group layer ids.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_layer_classes()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} vector.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-get_lazyload"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-get_lazyload}{}}}
\subsection{Method \code{get_lazyload()}}{
Get data frame of map manager layers.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$get_lazyload()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{data.frame} object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-initialize_map"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-initialize_map}{}}}
\subsection{Method \code{initialize_map()}}{
Initial map by adding data to it.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$initialize_map(map)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{map}}{\link[leaflet:leafletProxy]{leaflet::leafletProxy} object.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-update_map"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-update_map}{}}}
\subsection{Method \code{update_map()}}{
Update map.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$update_map(map)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{map}}{\code{\link[leaflet:leafletProxy]{leaflet::leafletProxy()}} object.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-delete_sinlge_map_pane"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-delete_sinlge_map_pane}{}}}
\subsection{Method \code{delete_sinlge_map_pane()}}{
Delete single map pane
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$delete_sinlge_map_pane(map)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{map}}{\code{\link[leaflet:leafletProxy]{leaflet::leafletProxy()}} object.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-delete_all_map_panes"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-delete_all_map_panes}{}}}
\subsection{Method \code{delete_all_map_panes()}}{
Delete all map panes.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$delete_all_map_panes(map)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{map}}{\code{\link[leaflet:leafletProxy]{leaflet::leafletProxy()}} object.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-MapManager-clone"></a>}}
\if{latex}{\out{\hypertarget{method-MapManager-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MapManager$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
