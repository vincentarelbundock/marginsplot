% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cplot_clm.R, R/cplot_extract.R, R/cplot_glm.R,
%   R/cplot_lm.R, R/cplot_loess.R, R/cplot_polr.R
\name{cplot_extract.clm}
\alias{cplot_extract.clm}
\alias{cplot_extract}
\alias{cplot_extract.default}
\alias{cplot_extract.glm}
\alias{cplot_extract.lm}
\alias{cplot_extract.loess}
\alias{cplot_extract.polr}
\alias{cplot_extract.multinom}
\title{Generic extracts model information for use by `cplot`}
\usage{
\method{cplot_extract}{clm}(
  object,
  data,
  dx,
  level,
  xvar,
  at,
  n,
  type,
  xvals,
  vcov,
  what,
  zvar,
  zvals,
  ...
)

cplot_extract(object, ...)

\method{cplot_extract}{default}(
  object,
  data,
  dx,
  level,
  xvar,
  zvar,
  xvals,
  zvals,
  at,
  n,
  type,
  vcov,
  what,
  ...
)

\method{cplot_extract}{glm}(
  object,
  data,
  dx,
  level,
  xvar,
  zvar,
  xvals,
  zvals,
  at,
  n,
  type,
  vcov,
  what,
  ...
)

\method{cplot_extract}{lm}(
  object,
  data,
  dx,
  level,
  xvar,
  zvar,
  xvals,
  zvals,
  at,
  n,
  type,
  vcov,
  what,
  ...
)

\method{cplot_extract}{loess}(
  object,
  data,
  dx,
  level,
  xvar,
  zvar,
  xvals,
  zvals,
  at,
  n,
  type,
  vcov,
  what,
  ...
)

\method{cplot_extract}{polr}(
  object,
  data,
  dx,
  level,
  xvar,
  at,
  n,
  type,
  xvals,
  vcov,
  what = c("prediction", "classprediction", "stackedprediction", "effect"),
  zvar,
  zvals,
  ...
)

\method{cplot_extract}{multinom}(
  object,
  data,
  dx,
  level,
  xvar,
  at,
  n,
  type,
  xvals,
  vcov,
  what = c("prediction", "classprediction", "stackedprediction", "effect"),
  zvar,
  zvals,
  ...
)
}
\arguments{
\item{object}{A statistical model object}

\item{data}{data.frame over which to calculate individual marginal effects
or predictions}

\item{dx}{The name of the variable whose effect should be plotted}

\item{level}{The confidence level required (used to draw uncertainty
bounds).}

\item{xvar}{The name of the variable to show on the x-axis}

\item{at}{Currently ignored.}

\item{n}{An integer specifying the number of points across \code{x} at which
to calculate the predicted value or marginal effect, when \code{x} is
numeric. Ignored otherwise.}

\item{type}{'response' or 'link'}

\item{xvals}{A numeric vector of values at which to calculate predictions or
marginal effects, if \code{x} is numeric. By default, it is calculated from
the data using \code{\link{seq_range}}. If \code{x} is a factor, this is
ignored, as is \code{n}.}

\item{vcov}{the variance-covariance matrix used to calculate confidence intervals}

\item{what}{The quantity to plot: 'prediction', 'effect', 'classprediction',
or 'stackedprediction'}

\item{zvar}{name of the third dimension variable over which quantities should
be plotted (as facets).}

\item{zvals}{discrete values of the z variable over which to plot}

\item{...}{Additional arguments such as \code{colour}, \code{linetype},
\code{size}, \code{shape}, \code{fill}, \code{alpha}. These will be passed
to \code{ggplot2} geom functions to alter the style of the plot.  If `x` is
a factor, these arguments will be passed to
\code{\link[ggplot2]{geom_pointrange}}. If `x` is numeric, these arguments
will be passed to \code{\link[ggplot2]{geom_line}} and
\code{\link[ggplot2]{geom_ribbon}}.  The \code{alpha} and \code{fill}
arguments are not passed to \code{geom_line}. The \code{colour} argument is
not passed to \code{geom_ribbon}.}
}
\description{
Generic extracts model information for use by `cplot`

Internal function to extract data for `cplot`
}
