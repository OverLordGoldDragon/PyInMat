
classdef viz_primitives
    properties(Constant)
        vscat = @vscat;
        vplot = @vplot;
        vplotscat = @vplotscat;
        vimshow = @vimshow;

        maybe_show = @maybe_show;
        get_fig_ax = @get_fig_ax;
    end
end


function vplot(x, y, C)
    arguments
        x;
        y = missing;
        C.complex = 0;
        C.title = missing;
        C.color = "None";
        C.show = false;
        C.fig = "None";
        C.ax = "None";
    end

    if ~isequal(C.color, "None") && contains(C.color, "tab:")
        C.color = G(C.color);
    end

    N = length(x);
    if ismissing(y)
        y = x;
        x = (0 : N - 1);
    end

    hold on
    [fig, ax] = get_fig_ax(C.fig, C.ax);

    if C.complex
        plot(ax, x, real(y), x, imag(y))
        if C.complex == 2
            plot(ax, x, abs(y), 'k--')
        end
    else
        if isequal(C.color, "None")
            plot(ax, x, y)
        else
            plot(ax, x, y, 'Color', C.color)
        end
    end

    ax = gca;
    if ~ismissing(C.title)
        title(C.title)
        ax.TitleHorizontalAlignment = 'left';
    end

    scale_plot_(ax, N);
    maybe_show(fig, ax, C.show)
end


function vscat(x, y, C)
    arguments
        x;
        y = missing;
        C.title = missing;
        C.show = false;
        C.ax = "None";
        C.fig = "None";
    end

    N = length(x);
    if ismissing(y)
        y = x;
        x = (0 : N - 1);
    end

    hold on
    [fig, ax] = get_fig_ax(C.fig, C.ax);

    scatter(ax, x, y, 10, G('tab:blue'), 'filled')
    
    if ~ismissing(C.title)
        title(C.title)
        ax.TitleHorizontalAlignment = 'left';
    end

    scale_plot_(ax, N);
    maybe_show(fig, ax, C.show)
end


function vplotscat(varargin)
    varargin_adj = remove_show_(varargin{:});

    hold on
    vplot(varargin_adj{:})
    vscat(varargin{:})
    hold off
end


function vimshow(x, C)
    arguments
        x;
        C.title = "None";
        C.show = true;
        C.cmap = "None";
        C.norm = "None";
        C.abs = 0;
        C.w = "None";
        C.h = "None";
        C.ticks = true;
        C.boders = true;
        C.aspect = "auto";
        C.ax = "None";
        C.fig = "None";
        C.yticks = "None";
        C.xticks = "None";
        C.xlabel = "None";
        C.ylabel = "None";
        C.kw = [];
    end
    
    hold on
    [fig, ax] = get_fig_ax(C.fig, C.ax);
    if C.abs
        x = abs(x);
    end

    % convert for color mapping
    xa = abs(x);  % TODO no

    % place min at 0, then rescale to be within [0, 255]
    offset = -wmin(xa);
    x = xa + offset;
    % rescale to be within [0, 255]
    scaling = 255 / wmax(x);
    x = x * scaling;
    if ~strcmp(class(x), "int32")
        x = int32(x);
    end

    % transform limits the same way
    if isequal(C.norm, "None")
        clims = [0 255];
    else
        clims = (C.norm + offset) * scaling;
        clims = round(max(0, min(255, clims)));
    end
    
    imagesc(ax, x);
    ax.CLim = clims;
    axis tight

    if ~isequal(C.title, "None")
        title(C.title)
        ax = gca;
        ax.TitleHorizontalAlignment = 'left';
    end

    maybe_show(fig, ax, C.show)
end


function scale_plot_(ax, N)
    inc = N / 100;
    xlim(ax, [0 - inc, N - 1 + inc])
end


function [fig, ax] = get_fig_ax(fig, ax)
    if nargin == 0
        fig = gcf();
        ax = gca();
    elseif nargin == 1
        ax = gca();
    else
        if isequal(fig, "None")
            fig = gcf();
        end
        if isequal(ax, "None")
            ax = gca();
        end
    end
end


function varargin_adj = remove_show_(varargin)
    isin = pyinmat.from_import('isin');
    if isin("show", varargin)
        % process args to delay `show=1` until we're done
        varargin_adj = cell(1, numel(varargin) - 2);

        j = 1;  % track `varargin` separately
        prev_was_show = false;
        for k=1:numel(varargin)
            key = varargin{k};
            if isequal(key, "show")
                prev_was_show = true;
            else
                if prev_was_show
                    % skip appending this one, reset flag so next ones append
                    prev_was_show = false;
                else
                    varargin_adj{j} = varargin{k};
                    j = j + 1;
                end
            end
        end
    else
        varargin_adj = varargin;
    end
end


function maybe_show(fig, ax, show_)
    fig.Visible = true;
    if show_
        figure('Visible', 'off')
        hold off
    end
end


function out = G(name)
    G_all = containers.Map();
    G_all('tab:blue') = [0 .4470 .7410];
    out = G_all(name);
end
