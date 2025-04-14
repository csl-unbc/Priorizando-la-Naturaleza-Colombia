#' Sever function: load solution
#'
#' Set behavior for loading a solution with a simple drop down menu
#'
#' @details
#' This object is designed to be used within [app_server] function.
#' Within the [app_server] function, it should be called like this:
#'
#' ```
#' eval(server_load_solution)
#' ```
#'
#' @noRd
server_load_solution <- quote({

  # create reactive value to store new results
  new_user_load_result <- shiny::reactiveVal()

  # load a solution when load_solution_button button pressed
  shiny::observeEvent(input$load_solution_button, {

    ## specify dependencies
    shiny::req(input$load_solution_list)
    shiny::req(input$load_solution_color)
    shiny::req(input$load_solution_button)

    ## update generate solution inputs
    disable_html_element("load_solution_list")
    disable_html_element("load_solution_color")
    disable_html_element("load_solution_button")

    ## add map spinner
    shinyjs::runjs(
    "const mapSpinner = document.createElement('div');
    mapSpinner.classList.add('map-spinner');
    document.body.appendChild(mapSpinner);"
    )

    ###### load solution settings from yaml file --------------------------------

    ## specify dependencies
    shiny::req(input$newSolutionPane_settings)

    ## update solution settings object
    app_data$ss$set_setting(input$newSolutionPane_settings)

    # get the yaml file path from input$load_solution_list change the extension to yaml preserving the path
    load_solution_settings <- gsub("-solution.tif$", "-solution.yaml", input$load_solution_list)

    ## load solution settings
    settings_lst <- try(yaml::yaml.load(enc2utf8(paste(readLines(load_solution_settings), collapse = "\n"))), silent = TRUE)
    updated_ss <- try(app_data$ss$update_ss(settings_lst), silent = TRUE)

    ### update solution settings widget
    if (identical(class(updated_ss), "try-error") || identical(class(settings_lst), "try-error")) {
      msg <- paste(
      "There was an error loading the settings from the yaml file of the solution selected."
      )
      ### display error modal
      shinyalert::shinyalert(
        title = "Oops",
        text = msg,
        size = "s",
        closeOnEsc = TRUE,
        closeOnClickOutside = TRUE,
        type = "error",
        showConfirmButton = TRUE,
        confirmButtonText = "OK",
        timer = 0,
        confirmButtonCol = "#0275d8",
        animation = TRUE
      )
    } else {
      ### update theme/feature status
      vapply(app_data$themes, FUN.VALUE = logical(1), function(x) {
        if ((!all(x$get_feature_status())) &
            (length(x$get_feature_status()) > 1)) {
          ### update group status
          updateSolutionSettings(
            inputId = "newSolutionPane_settings",
            value = list(
              id = x$id,
              setting = "status",
              value = FALSE,
              type = "theme"
            )
          )
        } else {
          ### update feature status
          updateSolutionSettings(
            inputId = "newSolutionPane_settings",
              value = list(
              id = x$id,
              setting = "feature_status",
              value = x$get_feature_status(),
              type = "theme"
            )
          )
        }
       #### return success
       TRUE
      })
      ### update theme/feature goal
      vapply(app_data$themes, FUN.VALUE = logical(1), function(x) {
        if ((length(unique(x$get_feature_goal())) == 1) &
            (length(x$get_feature_goal()) > 1)) {
          #### update group goal
          updateSolutionSettings(
            inputId = "newSolutionPane_settings",
            value = list(
              id = x$id,
              setting = "group_goal",
              value = unique(x$get_feature_goal()),
              type = "theme"
            )
          )
          ### update view to group tab
          updateSolutionSettings(
            inputId = "newSolutionPane_settings",
            value = list(
              id = x$id,
              setting = "view",
              value = "group",
              type = "theme"
            )
          )
        } else {
          ### update feature goal
          updateSolutionSettings(
            inputId = "newSolutionPane_settings",
            value = list(
              id = x$id,
              setting = "feature_goal",
              value = x$get_feature_goal(),
              type = "theme"
            )
          )
          ### update view to single tab
          updateSolutionSettings(
            inputId = "newSolutionPane_settings",
            value = list(
              id = x$id,
              setting = "view",
              value = "single",
              type = "theme"
            )
          )
        }
        #### return success
        TRUE
      })
      ### update weights status
      lapply(seq_along(app_data$weights), function(i) {
        updateSolutionSettings(
          inputId = "newSolutionPane_settings",
          value = list(
            id = app_data$ss$weights[[i]]$id,
            setting = "status",
            value = app_data$ss$weights[[i]]$status,
            type = "weight"
          )
        )
        ### update weight factor
        updateSolutionSettings(
          inputId = "newSolutionPane_settings",
          value = list(
            id = app_data$ss$weights[[i]]$id,
            setting = "factor",
            value = app_data$ss$weights[[i]]$factor,
            type = "weight"
          )
        )
      })
      ### update includes status
      lapply(seq_along(app_data$includes), function(i) {
        updateSolutionSettings(
          inputId = "newSolutionPane_settings",
          value = list(
            id = app_data$ss$includes[[i]]$id,
            setting = "status",
            value = app_data$ss$includes[[i]]$status,
            type = "include"
          )
         )
       })
      ### update excludes status
      lapply(seq_along(app_data$excludes), function(i) {
        updateSolutionSettings(
          inputId = "newSolutionPane_settings",
          value = list(
            id = app_data$ss$excludes[[i]]$id,
            setting = "status",
            value = app_data$ss$excludes[[i]]$status,
            type = "exclude"
          )
        )
      })
      ### update parameter status
      lapply(seq_along(app_data$ss$parameters), function(i) {
        updateSolutionSettings(
          inputId = "newSolutionPane_settings",
          value = list(
            id = app_data$ss$parameters[[i]]$id,
            setting = "status",
            value = app_data$ss$parameters[[i]]$status,
            type = "parameter"
          )
        )
      })
      ### update parameter value
      lapply(seq_along(app_data$ss$parameters), function(i) {
        updateSolutionSettings(
          inputId = "newSolutionPane_settings",
          value = list(
            id = app_data$ss$parameters[[i]]$id,
            setting = "value",
            value = app_data$ss$parameters[[i]]$value,
            type = "parameter"
          )
        )
      })

      ## if updating include status,
      ## then update the current amount for each feature within each theme
      if ((identical(input$newSolutionPane_settings$type, "include")) |
         (exists("updated_ss") && identical(class(updated_ss), "list"))) {
        ### update object
        app_data$ss$update_current_held(
          theme_data = app_data$theme_data,
          include_data = app_data$include_data
        )

        ### update widget
        vapply(app_data$themes, FUN.VALUE = logical(1), function(x) {
          ### update the widget
          updateSolutionSettings(
            inputId = "newSolutionPane_settings",
            value = list(
              id = x$id,
              setting = "feature_current",
              value = x$get_feature_current(),
              type = "theme"
            )
          )
          #### return success
          TRUE
        })
      }
    }

    ###### load solution --------------------------------------------------------

    ## generate id and store it in app_data
    curr_id <- uuid::UUIDgenerate()
    app_data$new_load_solution_id <- curr_id

    ## extract values for generating result
    ### settings
    curr_theme_settings <- app_data$ss$get_theme_settings()
    curr_weight_settings <- app_data$ss$get_weight_settings()
    curr_include_settings <- app_data$ss$get_include_settings()
    curr_exclude_settings <- app_data$ss$get_exclude_settings()
    ### data
    curr_area_data <- app_data$area_data
    curr_boundary_data <- app_data$boundary_data
    curr_theme_data <- app_data$theme_data
    curr_weight_data <- app_data$weight_data
    curr_include_data <- app_data$include_data
    curr_exclude_data <- app_data$exclude_data
    ### arguments for generating result
    curr_time_limit_1 <- get_golem_config("solver_time_limit_1")
    curr_time_limit_2 <- get_golem_config("solver_time_limit_2")
    curr_gap_1 <- get_golem_config("solver_gap_1")
    curr_gap_2 <- get_golem_config("solver_gap_2")
    curr_verbose <- get_golem_config("verbose")
    curr_color <- scales::alpha(input$load_solution_color, 0.8)
    curr_type <- app_data$ss$get_parameter("budget_parameter")$status
    curr_cache <- app_data$cache
    curr_area_budget <- c(
      app_data$ss$get_parameter("budget_parameter")$value *
      app_data$ss$get_parameter("budget_parameter")$status
    ) / 100
    curr_boundary_gap <- c(
      app_data$ss$get_parameter("spatial_parameter")$value *
      app_data$ss$get_parameter("spatial_parameter")$status
    ) / 100
    curr_parameters <- lapply(app_data$ss$parameters, function(x) x$clone())
    curr_overlap <- app_data$ss$get_parameter("overlap_parameter")$status
    #### gurobi web license server check-in
    try_gurobi <- input$newSolutionPane_settings_gurobi
    #### load solution path
    load_solution <- input$load_solution_list
    #### solution name
    curr_name <- gsub("-", " ", tools::file_path_sans_ext(basename(load_solution)))

    ## generate result using asynchronous task
    app_data$task <- future::future(packages = "wheretowork", seed = NULL, {
      ### main processing
      if (curr_type) {
        #### if budget specified, then use the min shortfall formulation
        r <- try(
          min_shortfall_result(
            id = curr_id,
            area_budget_proportion = curr_area_budget,
            area_data = curr_area_data,
            boundary_data = curr_boundary_data,
            theme_data = curr_theme_data,
            weight_data = curr_weight_data,
            include_data = curr_include_data,
            exclude_data = curr_exclude_data,
            theme_settings = curr_theme_settings,
            weight_settings = curr_weight_settings,
            include_settings = curr_include_settings,
            exclude_settings = curr_exclude_settings,
            parameters = curr_parameters,
            overlap = curr_overlap,
            gap_1 = curr_gap_1,
            gap_2 = curr_gap_2,
            boundary_gap = curr_boundary_gap,
            cache = curr_cache,
            time_limit_1 = curr_time_limit_1,
            time_limit_2 = curr_time_limit_2,
            verbose = curr_verbose,
            try_gurobi = try_gurobi,
            load_solution = load_solution
          ),
          silent = TRUE
        )
      } else {
        #### else, then use the min set formulation
        r <- try(
          min_set_result(
            id = curr_id,
            area_data = curr_area_data,
            boundary_data = curr_boundary_data,
            theme_data = curr_theme_data,
            weight_data = curr_weight_data,
            include_data = curr_include_data,
            exclude_data = curr_exclude_data,
            theme_settings = curr_theme_settings,
            weight_settings = curr_weight_settings,
            include_settings = curr_include_settings,
            exclude_settings = curr_exclude_settings,
            parameters = curr_parameters,
            overlap = curr_overlap,
            gap_1 = curr_gap_1,
            gap_2 = curr_gap_2,
            boundary_gap = curr_boundary_gap,
            cache = curr_cache,
            time_limit_1 = curr_time_limit_1,
            time_limit_2 = curr_time_limit_2,
            verbose = curr_verbose,
            try_gurobi = try_gurobi,
            load_solution = load_solution
          ),
          silent = TRUE
        )
      }
      ## return result
      r <- list(
        id = curr_id, name = curr_name, color = curr_color,
        result = r, cache = curr_cache
      )
    })
    ## add promises to handle result once asynchronous task finished
      prom <-
        (app_data$task) %...>%
        (function(result) {
          new_user_load_result(result)
          app_data$cache <- result$cache
        }) %...!%
        (function(error) {
          new_user_load_result(NULL)
          if (!is.null(app_data$new_load_solution_id)) {
            warning(error)
          }
          NULL
        })

      ## this needed to implement asynchronous processing,
      ## see https://github.com/rstudio/promises/issues/23
      NULL
    }
  )

  # add solution to map when generating new solution
  shiny::observeEvent(new_user_load_result(), {
    ## specify dependencies
    if (is.null(new_user_load_result()) || is.null(app_data$new_load_solution_id)) {
      return()
    }
    if (!identical(new_user_load_result()$id, app_data$new_load_solution_id)) {
      return()
    }

    ## extract result
    r <- new_user_load_result()

    ## generate solution from result
    s <- new_solution_from_result(
      id = uuid::UUIDgenerate(),
      result = r$result,
      name = r$name,
      visible = if (app_data$ss$get_parameter("solution_layer_parameter")$status) FALSE else TRUE,
      hidden = app_data$ss$get_parameter("solution_layer_parameter")$status,
      dataset = app_data$dataset,
      settings = app_data$ss,
      legend = new_manual_legend(
        values = c(0, 1),
        colors = c("#00FFFF00", r$color),
        labels = c("not selected", "selected")
      )
    )
    rm(r)

    ## make leaflet proxy
    map <- leaflet::leafletProxy("map")

    ## store solution
    app_data$solutions <- append(app_data$solutions, list(s))

    ## store solution id and names
    app_data$solution_ids <-
      c(app_data$solution_ids, stats::setNames(s$id, s$name))

    ## add new solution to the map
    app_data$mm$add_layer(s, map)

    ## add new solution to map manager widget
    addMapManagerLayer(
      session = session,
      inputId = "mapManagerPane_settings",
      value = s
    )

    ## add new solution to solution results widget
    addSolutionResults(
      session = session,
      inputId = "solutionResultsPane_results",
      value = s
    )

    ## add new solution to export sidebar
    shiny::updateSelectizeInput(
      session = session,
      inputId = "exportPane_fields",
      choices = stats::setNames(
        app_data$mm$get_layer_indices(download_only = TRUE),
        app_data$mm$get_layer_names(download_only = TRUE)
      )
    )

    ## add new solution to solution results modal
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "solutionResultsPane_results_modal_select",
      choices = app_data$solution_ids,
      selected = dplyr::last(app_data$solution_ids)
    )

    ## show the new solution in the results widget
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "solutionResultsPane_results_select",
      choices = app_data$solution_ids,
      selected = dplyr::last(app_data$solution_ids)
    )
    showSolutionResults(
      session = session,
      inputId = "solutionResultsPane_results",
      value = s$id
    )

    ## show solution results sidebar
    leaflet.extras2::openSidebar(
      map,
      id = "solutionResultsPane", sidebar_id = "analysisSidebar"
    )

    ## enable solution results modal button after generating first solution
    if (length(app_data$solutions) == 1) {
      enable_html_css_selector("#analysisSidebar li:nth-child(2)")
    }

    ## remove map spinner
    shinyjs::runjs(
    "document.querySelector('.map-spinner').remove();"
    )

    ### reset buttons
    shinyFeedback::resetLoadingButton("load_solution_button")
    enable_html_element("load_solution_list")
    enable_html_element("load_solution_color")
    # select the default item "" in the pickerInput load_solution_list
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "load_solution_list",
      selected = ""
    )
    disable_html_element("load_solution_button")

  })

})