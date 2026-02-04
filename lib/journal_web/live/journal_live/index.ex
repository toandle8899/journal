defmodule JournalWeb.JournalLive.Index do
  use JournalWeb, :live_view
  alias Journal.Journals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :entries, list_entries(socket))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Journal.Journals.get_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Journal.Journals.Entry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "The Archives")
    |> assign(:entry, nil)
    |> stream(:entries, list_entries(socket), reset: true)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Journal.Journals.get_entry!(id)
    {:ok, _} = Journal.Journals.destroy_entry(entry, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :entries, entry)}
  end

  @impl true
  def handle_info({:entry_created, entry}, socket) do
    {:noreply, stream_insert(socket, :entries, entry, at: 0)}
  end
  
  defp list_entries(socket) do
    {:ok, entries} = Journals.read_entries(actor: socket.assigns.current_user)
    Enum.sort_by(entries, & &1.date, Date) |> Enum.reverse() 
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen relative">
      <!-- Vintage Library Header -->
      <header class="sticky top-0 z-40 backdrop-blur-md bg-base-100/80 border-b-2 border-primary/30 shadow-lg">
        <div class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
          <div class="flex items-center gap-4">
            <!-- Dewey Decimal Style Number -->
            <span class="font-mono text-primary text-sm tracking-wider opacity-70">№ 920.02</span>
            <div>
              <h1 class="text-2xl font-display text-primary tracking-wide"><%= @page_title %></h1>
              <p class="text-xs font-mono text-base-content/50 tracking-widest uppercase">Personal Archives</p>
            </div>
          </div>
          
          <%= if @current_user do %>
            <div class="flex items-center gap-6">
              <div class="text-right border-r border-base-content/20 pr-6">
                <p class="text-xs font-mono text-base-content/40 uppercase tracking-wider">Catalogued by</p>
                <p class="text-sm font-serif text-base-content/80"><%= @current_user.email %></p>
              </div>
              <a href="/sign-out" class="group flex items-center gap-2 px-4 py-2 border border-base-content/20 hover:border-primary/50 transition-all duration-300 hover:shadow-md">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4 text-base-content/50 group-hover:text-primary transition-colors">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75" />
                </svg>
                <span class="text-xs font-mono uppercase tracking-widest text-base-content/60 group-hover:text-primary transition-colors">Exit</span>
              </a>
            </div>
          <% end %>
        </div>
      </header>

      <!-- Main Content - Card Catalog Grid -->
      <main class="max-w-6xl mx-auto px-6 py-12">
        <!-- Modal for New/Edit -->
        <%= if @live_action in [:new, :edit] do %>
          <div class="fixed inset-0 z-50 flex items-center justify-center bg-base-300/90 backdrop-blur-sm p-4" style="animation: fadeIn 0.2s ease-out;">
            <div class="w-full max-w-3xl relative" style="animation: slideUp 0.3s ease-out;">
              <.live_component
                module={JournalWeb.JournalLive.FormComponent}
                id={@entry.id || :new}
                title={@page_title}
                action={@live_action}
                entry={@entry}
                current_user={@current_user}
                patch={~p"/journals"}
              />
              <.link patch={~p"/journals"} class="absolute -top-10 right-0 px-4 py-2 border border-base-content/30 hover:border-primary/50 text-base-content/50 hover:text-primary transition-all text-xs font-mono uppercase tracking-widest">
                [Close]
              </.link>
            </div>
          </div>
        <% end %>

        <!-- Card Catalog Entries -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" id="entries" phx-update="stream">
          <%= for {id, entry} <- @streams.entries do %>
            <article 
              id={id} 
              class="group relative bg-base-200/50 border-2 border-base-content/10 hover:border-primary/40 transition-all duration-500 hover:shadow-2xl hover:-translate-y-1"
              style={"animation: cardReveal 0.6s ease-out #{rem(String.to_integer(String.slice(id, -2..-1), 16), 6) * 0.1}s backwards;"}
            >
              <!-- Card Header - Library Card Style -->
              <div class="border-b border-base-content/10 px-6 py-4 bg-base-100/30">
                <div class="flex justify-between items-start gap-4">
                  <div class="flex-1">
                    <time class="block text-xs font-mono text-secondary mb-1 uppercase tracking-widest">
                      <%= Calendar.strftime(entry.date, "%d %b %Y") %>
                    </time>
                    <h2 class="text-xl font-display text-primary leading-tight group-hover:text-primary/80 transition-colors">
                      <%= entry.title %>
                    </h2>
                  </div>
                  <!-- Catalog Number -->
                  <span class="text-xs font-mono text-base-content/30 tracking-wider">
                    #<%= String.slice(entry.id, 0..5) %>
                  </span>
                </div>
              </div>

              <!-- Card Content -->
              <div class="px-6 py-5">
                <div class="text-base font-serif text-base-content/70 leading-relaxed line-clamp-4 group-hover:line-clamp-none transition-all duration-500">
                  <%= entry.content %>
                </div>
              </div>

              <!-- Card Footer - Actions -->
              <div class="border-t border-base-content/10 px-6 py-3 bg-base-100/20 flex justify-between items-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <.link patch={~p"/journals/#{entry}/edit"} class="text-xs font-mono uppercase tracking-widest text-base-content/50 hover:text-primary transition-colors">
                  [Edit]
                </.link>
                <button 
                  phx-click="delete" 
                  phx-value-id={entry.id} 
                  data-confirm="Remove this entry from the archives?" 
                  class="text-xs font-mono uppercase tracking-widest text-base-content/50 hover:text-error transition-colors"
                >
                  [Remove]
                </button>
              </div>
            </article>
          <% end %>
        </div>
      </main>

      <!-- Floating Add Button - Vintage Stamp Style -->
      <.link 
        patch={~p"/journals/new"} 
        class="fixed bottom-8 right-8 group"
        style="animation: stampAppear 0.8s ease-out 0.5s backwards;"
      >
        <div class="relative">
          <!-- Stamp Border -->
          <div class="absolute inset-0 border-4 border-primary/30 rounded-full" style="border-style: dashed;"></div>
          <!-- Inner Circle -->
          <div class="relative w-16 h-16 bg-primary hover:bg-primary/90 rounded-full flex items-center justify-center shadow-2xl transition-all duration-300 hover:scale-110 hover:rotate-12">
            <span class="text-3xl text-primary-content font-display">+</span>
          </div>
          <!-- Stamp Text -->
          <div class="absolute -bottom-8 left-1/2 -translate-x-1/2 whitespace-nowrap">
            <span class="text-xs font-mono uppercase tracking-widest text-primary/70">New Entry</span>
          </div>
        </div>
      </.link>
    </div>

    <style>
      @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
      }
      
      @keyframes slideUp {
        from { 
          opacity: 0;
          transform: translateY(20px);
        }
        to { 
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      @keyframes cardReveal {
        from {
          opacity: 0;
          transform: translateY(30px) rotateX(10deg);
        }
        to {
          opacity: 1;
          transform: translateY(0) rotateX(0deg);
        }
      }
      
      @keyframes stampAppear {
        from {
          opacity: 0;
          transform: scale(0) rotate(-180deg);
        }
        to {
          opacity: 1;
          transform: scale(1) rotate(0deg);
        }
      }
    </style>
    """
  end
end
