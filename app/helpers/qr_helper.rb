module QrHelper
  def qr_svg_for(url, module_size: 6)
    qr = RQRCode::QRCode.new(url)
    svg = qr.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: module_size,
      standalone: true,
      use_path: true
    )
    svg.html_safe
  end
end
