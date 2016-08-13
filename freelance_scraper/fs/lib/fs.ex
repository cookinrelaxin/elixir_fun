defmodule Fs do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Task.start_link(fn -> scrape(1,3) end)
  end

  def scrape(start, finish) do
    case start <= finish do
      true ->
        url = "https://www.freelancer.com/jobs/#{start}/" 
        %{:status_code => status_code,
          :body => body,
          :headers => headers} = HTTPoison.get!(url)
          ps = Floki.find(body, "tr.ProjectTable-row.project-details.odd")
        loop_ps(ps)
        scrape(start+1, finish)
      false ->
        {:ok}
    end
  end

  defp loop_ps([head | []]) do
    IO.inspect extract_title(head)
  end

  defp loop_ps([head | tail]) do
    IO.inspect extract_title(head)
    loop_ps(tail)
  end

  defp extract_title(unextracted) do
      title = unextracted
        |> elem(2)
        |> hd
        |> elem(2)
        |> hd
        |> String.downcase
        |> String.strip
      title
  end

          # description = ps
          #   |> hd
          #   |> elem(2)
          #   |> tl
          #   |> hd
          #   |> elem(2)
          #   |> hd

end
