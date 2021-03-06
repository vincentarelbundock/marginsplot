#' @rdname cplot
#' @title Conditional predicted value and average marginal effect plots for models
#' @description Draw one or more conditional effects plots reflecting
#'   model coefficients, or a function to perform the estimation with
#'   \code{model} as its only argument.
#' @param object A statistical model object
#' @param x The name of the variable to show on the x-axis
#' @param dx The name of the variable whose effect should be plotted
#' @param what The quantity to plot: 'prediction', 'effect', 'classprediction',
#'   or 'stackedprediction'
#' @param type 'response' or 'link'
#' @param vcov the variance-covariance matrix used to calculate confidence intervals
#' @param z name of the third dimension variable over which quantities should
#'   be plotted (as facets).
#' @param zvals discrete values of the z variable over which to plot
#' @param n An integer specifying the number of points across \code{x} at which
#'   to calculate the predicted value or marginal effect, when \code{x} is
#'   numeric. Ignored otherwise.
#' @param xvals A numeric vector of values at which to calculate predictions or
#'   marginal effects, if \code{x} is numeric. By default, it is calculated from
#'   the data using \code{\link{seq_range}}. If \code{x} is a factor, this is
#'   ignored, as is \code{n}.
#' @param data data.frame over which to calculate individual marginal effects
#'   or predictions
#' @param level The confidence level required (used to draw uncertainty
#'   bounds).
#' @param draw A logical (default \code{TRUE}), specifying whether to draw the
#'   plot. If \code{FALSE}, the data used in drawing are returned as a list of
#'   data.frames. This might be useful if you want to plot using an alternative
#'   plotting package (e.g., ggplot2). Also, if set to value \dQuote{add}, then
#'   the resulting data is added to the existing plot.
#' @param rugplot logical include a rugplot at the bottom of the graph 
#' @param at Currently ignored.
#' @param \dots Additional arguments such as \code{colour}, \code{linetype},
#'   \code{size}, \code{shape}, \code{fill}, \code{alpha}. These will be passed
#'   to \code{ggplot2} geom functions to alter the style of the plot.  If `x` is
#'   a factor, these arguments will be passed to
#'   \code{\link[ggplot2]{geom_pointrange}}. If `x` is numeric, these arguments
#'   will be passed to \code{\link[ggplot2]{geom_line}} and
#'   \code{\link[ggplot2]{geom_ribbon}}.  The \code{alpha} and \code{fill}
#'   arguments are not passed to \code{geom_line}. The \code{colour} argument is
#'   not passed to \code{geom_ribbon}.
#'  
#' @details Note that when \code{what = "prediction"}, the plots show
#' predictions holding values of the data at their mean or mode, whereas when
#' \code{what = "effect"} average marginal effects (i.e., at observed values)
#' are shown.
#' 
#' When examining generalized linear models (e.g., logistic regression models),
#' confidence intervals for predictions can fall outside of the response scale
#' (again, for logistic regression this means confidence intervals can exceed
#' the (0,1) bounds). This is consistent with the behavior of
#' \code{\link[stats]{predict}} but may not be desired. The examples (below)
#' show ways of constraining confidence intervals to these bounds.
#' 
#' The overall aesthetic is somewhat similar to to the output produced by the
#' \code{marginalModelPlot()} function in the
#' \bold{\href{https://cran.r-project.org/package=car}{car}} package.
#' 
#' @return A ggplot2 object. Use \code{draw = FALSE} to simply generate the
#' data structure for use elsewhere.
#'
#' @examples
#' \dontrun{
#' require('datasets')
#' # prediction from several angles
#' m <- lm(Sepal.Length ~ Sepal.Width, data = iris)
#' cplot(m)
#' 
#' # marginal effect of 'Petal.Width' across 'Petal.Width'
#' m <- lm(Sepal.Length ~ Sepal.Width * Petal.Width * I(Petal.Width ^ 2), 
#'         data = head(iris, 50))
#' cplot(m, x = "Petal.Width", what = "effect", n = 10)
#'
#' # factor independent variables
#' mtcars[["am"]] <- factor(mtcars[["am"]])
#' m <- lm(mpg ~ am * wt, data = mtcars)
#'
#' ## predicted values for each factor level
#' cplot(m, x = "am")
#'
#' ## marginal effect of each factor level across numeric variable
#' cplot(m, x = "wt", dx = "am", what = "effect")
#' 
#' # non-linear model
#' m <- glm(am ~ wt*drat, data = mtcars, family = binomial)
#' cplot(m, x = "wt", type = 'response') # prediction (response scale)
#' cplot(m, x = "wt", type = 'link') # prediction (link scale)
#'
#' # marginal effect of 'Petal.Width' across 'Sepal.Width'
#' ## without drawing the plot
#' ## this might be useful if you want even more control over the plots
#' tmp <- cplot(m, x = "Sepal.Width", dx = "Petal.Width", 
#'              what = "effect", n = 10, draw = FALSE)
#' 
#' # effects on linear predictor and outcome
#' cplot(m, x = "drat", dx = "wt", what = "effect", type = "link")
#' cplot(m, x = "drat", dx = "wt", what = "effect", type = "response")
#' 
#' # ordinal outcome
#' if (require("MASS")) {
#'   # x is a factor variable
#'   house.plr <- polr(Sat ~ Infl + Type + Cont, weights = Freq, 
#'                     data = housing)
#'   ## predicted probabilities
#'   cplot(house.plr)
#'   ## cumulative predicted probabilities
#'   cplot(house.plr, what = "stacked")
#'   ## ggplot2 example
#'   if (require("ggplot2")) {
#'     ggplot(cplot(house.plr), aes(x = xvals, y = yvals, group = level)) + 
#'       geom_line(aes(color = level))
#'   }
#'
#'   # x is continuous
#'   cyl.plr <- polr(factor(cyl) ~ wt, data = mtcars)
#'   cplot(cyl.plr, col = c("red", "purple", "blue"), what = "stacked")
#'   cplot(cyl.plr, what = "class")
#' }
#' 
#' }
#' @seealso \code{\link{plot.margins}}, \code{\link{persp.lm}}
#' @keywords graphics
#' @importFrom ggplot2 ggplot aes_string geom_line geom_ribbon geom_pointrange geom_rug xlab ylab theme_minimal theme_classic facet_wrap
#' @importFrom utils head
#' @importFrom graphics par plot lines rug polygon segments points
#' @importFrom prediction prediction find_data seq_range mean_or_mode
#' @export
cplot <- function(object, 
                  x = NULL,
                  dx = NULL, 
                  what = c("prediction", "effect", "classprediction", "stackedprediction"), 
                  type = c("response", "link"), 
                  vcov = stats::vcov(object),
                  data = NULL,
                  level = 0.95,
                  draw = TRUE,
                  xvals = NULL,
                  z = NULL,
                  zvals = NULL,
                  n = 25,
                  rugplot = TRUE,
                  at = NULL,
                  ...) {
                
    # default values
    if (is.null(data)) {
        data <- prediction::find_data(object)
    }
    
    # instead of using different selection mechanisms with conditionals 
    # throughout, we coerce data.table to data.frame
    if (inherits(data, 'data.table')) {
        data <- data.frame(data)
    }

    if (is.null(x)) {
        x <- attributes(terms(object))[["term.labels"]][1L]
    }

    if (is.null(dx)) {
        dx <- x
    }

    # parse arguments
    what <- match.arg(what)
    type <- match.arg(type)
    extra_args <- list(...)

    # prepare data for plotting
    out <- cplot_extract(object = object, 
                         data = data, 
                         dx = dx, 
                         xvar = x, 
                         xvals = xvals,
                         what = what, 
                         type = type, 
                         zvar = z,
                         zvals = zvals,
                         vcov = vcov,
                         at = at,
                         n = n,
                         level = level)

    # plot
    if (isTRUE(draw)) {

        # save for future queries (e.g., levels)
        outdat <- out 

        out <- ggplot(outdat, aes_string(x = 'xvals', y = 'yvals'))


        # x is numeric -> geom_line + geom_ribbon
        if (is.numeric(outdat$xvals)) {

            # confidence intervals are available -> geom_ribbon
            if (all(c('lower', 'upper') %in% names(outdat))) {

                # default look options 
                extra_args_ribbon <- extra_args
                if (!'alpha' %in% names(extra_args)) {
                    extra_args_ribbon[['alpha']] <- 0.3
                }
                if (!'fill' %in% names(extra_args)) {
                    extra_args_ribbon[['fill']] <- 'grey'
                }

                extra_args_ribbon[['mapping']] <- aes_string(ymin = 'lower', ymax = 'upper')
                extra_args_ribbon[['colour']] <- NULL # don't draw an ugly border around the CI
                out <- out + do.call('geom_ribbon', extra_args_ribbon)

            }

            # geom_line for estimates (draw over the ribbon)
            extra_args_line <- extra_args
            extra_args_line[['alpha']] <- NULL # transparent mfx lines don't look good
            extra_args_line[['fill']] <- NULL # argument not recognized by geom_line
            out  <- out + do.call('geom_line', extra_args_line)

            # rugplot
            if (rugplot) {
                rugdat <- data.frame('x' = data[[x]])
                out <- out + geom_rug(data = rugdat, aes_string(x = 'x'), inherit.aes=FALSE)
            }

        # x is not numeric
        } else {

            # confidence intervals are available -> geom_pointrange
            if (all(c('lower', 'upper') %in% names(outdat))) {
                extra_args_pointrange <- extra_args
                extra_args_pointrange[['mapping']] <- aes_string(ymin = 'lower', ymax = 'upper')
                extra_args_pointrange$fill <- NULL # argument not recognized by geom_pointrange
                out <- out + do.call('geom_pointrange', extra_args_pointrange)

            # confincence intervals are not available -> geom_point
            } else {
                extra_args_point <- extra_args
                extra_args_point$fill <- NULL # argument not recognized by geom_point
                out <- out + do.call('geom_point', extra_args_point)
            }

        }

        # axis labels
        if (what == 'prediction') {
            out <- out + ylab('Predicted value')
        } else if (what == 'effect') {
            out <- out + ylab(paste('Marginal effect of', dx))
        } else if (what == 'stackedprediction') {
            out <- out + ylab('Predicted value')
            ylabel <- 'Predicted value'
        } else if (what == 'classprediction') {
            out <- out + ylab('Predicted class')
        }
        out <- out + xlab(x)

        # theme
        out <- out + theme_minimal()

        # facet_wrap if `level` is in the extracted data
        if ('zvals' %in% names(outdat)) {
            out <- out +
                   facet_wrap(~ zvals) + 
                   theme_classic() # minimal facets are hard to read
        }

    }

    # output
    return(out)
}
