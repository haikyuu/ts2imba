import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
import debug from 'debug';
import { RequestHandler, Response } from 'express';

const log = debug('inertia-node-adapter:express');

type props = Record<string | number | symbol, unknown>;

export type Options = {
  readonly enableReload?: boolean;
  readonly version: string;
  readonly html: (page: Page, viewData: props) => string;
  readonly flashMessages?: (req: unknown) => props;
};

export type Page = {
  readonly component: string;
  props: props;
  readonly url: string;
  readonly version: string;
};
export type Inertia = {
  readonly setViewData: (viewData: props) => Inertia;
  readonly shareProps: (sharedProps: props) => Inertia;
  readonly setStatusCode: (statusCode: number) => Inertia;
  readonly setHeaders: (headers: Record<string, string>) => Inertia;
  readonly render: (Page: Page) => Promise<Response>;
  readonly redirect: (url: string) => Response;
};
export const headers = {
  xInertia: 'x-inertia',
  xInertiaVersion: 'x-inertia-version',
  xInertiaLocation: 'x-inertia-location',
  xInertiaPartialData: 'x-inertia-partial-data',
  xInertiaPartialComponent: 'x-inertia-partial-component',
  xInertiaCurrentComponent: 'x-inertia-current-component',
};
const inertiaExpressAdapter: (options: Options) => RequestHandler = function ({
  version,
  html,
  flashMessages,
  enableReload = false,
}) {
  return (req, res, next) => {
    if (
      req.method === 'GET' &&
      req.headers[headers.xInertia] &&
      req.headers[headers.xInertiaVersion] !== version
    ) {
      return req.session.destroy(() => {
        res.writeHead(409, { [headers.xInertiaLocation]: req.url }).end();
      });
    }

    let _viewData = {};
    let _sharedProps: props = {};
    let _statusCode = 200;
    let _headers: Record<string, string | string[] | undefined> = {};

    const Inertia: Inertia = {
      setViewData(viewData) {
        _viewData = viewData;
        return this;
      },

      shareProps(sharedProps) {
        _sharedProps = { ..._sharedProps, ...sharedProps };
        return this;
      },

      setStatusCode(statusCode) {
        _statusCode = statusCode;
        return this;
      },

      setHeaders(headers) {
        _headers = { ...req.headers, ..._headers, ...headers };
        return this;
      },
      async render({ props, ...pageRest }) {

        const _page: Page = {
          ...pageRest,
          url: req.originalUrl || req.url,
          version,
          props,
        };
        log('rendering', _page);
        if (flashMessages) {
          log('Flashing messages');
          this.shareProps({ flash: flashMessages(req) });
        }
        if (enableReload) {
          log('Setting session for reloading components');
          req.session.xInertiaCurrentComponent = pageRest.component;
        }
        const allProps = { ..._sharedProps, ...props };

        let dataKeys;
        const partialDataHeader = req.headers[headers.xInertiaPartialData];
        if (
          partialDataHeader &&
          req.headers[headers.xInertiaPartialComponent] === _page.component &&
          typeof partialDataHeader === 'string'
        ) {
          dataKeys = partialDataHeader.split(',');
        } else {
          log(
            'partial requests without the name of the component return a full request',
            _page.component
          );
          log(
            'header partial component',
            req.headers[headers.xInertiaPartialComponent]
          );
          dataKeys = Object.keys(allProps);
        }

        // we need to clear the props object on each call
        const propsRecord: props = {};
        for await (const key of dataKeys) {
          log('parsing props keys', dataKeys);
          let value;
          if (typeof allProps[key] === 'function') {
            value = await (allProps[key] as () => unknown)();
            log('prop promise resolved', key);
          } else {
            value = allProps[key];
          }
          propsRecord[key] = value;
        }
        _page.props = propsRecord;
        log('Page props built', _page.props);

        if (req.headers[headers.xInertia]) {
          res
            .status(_statusCode)
            .set({
              // ...req.headers,
              ..._headers,
              'Content-Type': 'application/json',
              [headers.xInertia]: 'true',
              Vary: 'Accept',
            })
            .send(JSON.stringify(_page));
          log("sent response with headers");
          log(res.getHeaders());
        } else {
          log('Sending the default html as no inertia header is present');
          res
            .status(_statusCode)
            .set({
              ...req.headers,
              ..._headers,
              'Content-Type': 'text/html',
            })
            .send(html(_page, _viewData));
        }
        return res;
      },

      redirect(url) {
        const statusCode = ['PUT', 'PATCH', 'DELETE'].includes(req.method)
          ? 303
          : 302;
        res.redirect(statusCode, url);
        log("Redirecting to {req.method} {url}");
        return res;
      },
    };

    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    req.Inertia = Inertia;

    return next();
  };
};
export default inertiaExpressAdapter;
'''

let imba-code = '''
import debug from "debug"
import {RequestHandler,Response} from "express"
const log = debug("inertia-node-adapter:express")
export const headers = 
	xInertia: "x-inertia"
	xInertiaVersion: "x-inertia-version"
	xInertiaLocation: "x-inertia-location"
	xInertiaPartialData: "x-inertia-partial-data"
	xInertiaPartialComponent: "x-inertia-partial-component"
	xInertiaCurrentComponent: "x-inertia-current-component"
const inertiaExpressAdapter = do({version, html, flashMessages, enableReload = false})
	return do(req, res, next)
		if req.method === "GET" and req.headers[headers.xInertia] and req.headers[headers.xInertiaVersion] !== version
			return req.session.destroy(do
				res.writeHead(409, [headers.xInertiaLocation]: [req.url]).end()
			)
		let _viewData = {}
		let _sharedProps = {}
		let _statusCode = 200
		let _headers = {}
		const Inertia = 
			setViewData: do(viewData)
				_viewData = viewData
				return this
			shareProps: do(sharedProps)
				_sharedProps = {
					..._sharedProps
					...sharedProps
				}
				return this
			setStatusCode: do(statusCode)
				_statusCode = statusCode
				return this
			setHeaders: do(headers2)
				_headers = {
					...req.headers
					..._headers
					...headers2
				}
				return this
			render: do({props, ...pageRest})
				const _page = {
					...pageRest
					url: req.originalUrl or req.url
					version: version
					props: props
				}
				log "rendering", _page
				if flashMessages
					log "Flashing messages"
					shareProps flash: flashMessages(req)
				if enableReload
					log "Setting session for reloading components"
					req.session.xInertiaCurrentComponent = pageRest.component
				const allProps = {
					..._sharedProps
					...props
				}
				let dataKeys
				const partialDataHeader = req.headers[headers.xInertiaPartialData]
				if partialDataHeader and req.headers[headers.xInertiaPartialComponent] === _page.component and typeof partialDataHeader === "string"
					dataKeys = partialDataHeader.split(",")
				else
					log "partial requests without the name of the component return a full request", _page.component
					log "header partial component", req.headers[headers.xInertiaPartialComponent]
					dataKeys = Object.keys(allProps)
				const propsRecord = {}
				for key in dataKeys
					log "parsing props keys", dataKeys
					let value
					if typeof allProps[key] === "function"
						value = await allProps[key]()
						log "prop promise resolved", key
					else
						value = allProps[key]
					propsRecord[key] = value
				_page.props = propsRecord
				log "Page props built", _page.props
				if req.headers[headers.xInertia]
					res.status(_statusCode).set({
						..._headers
						"Content-Type": "application/json"
						[headers.xInertia]: "true"
						Vary: "Accept"
					}).send JSON.stringify(_page)
					log "sent response with headers"
					log res.getHeaders()
				else
					log "Sending the default html as no inertia header is present"
					res.status(_statusCode).set({
						...req.headers
						..._headers
						"Content-Type": "text/html"
					}).send html(_page, _viewData)
				return res
			redirect: do(url)
				const statusCode = [
					"PUT"
					"PATCH"
					"DELETE"
				].includes(req.method) ? 303 : 302
				res.redirect statusCode, url
				log "Redirecting to {req.method} {url}"
				res
		req.Inertia = Inertia
		return next()

export default inertiaExpressAdapter

'''
test 'inertia example' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')